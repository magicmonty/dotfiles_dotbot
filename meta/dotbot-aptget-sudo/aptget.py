# coding=utf-8
import os
import subprocess
import dotbot
from enum import Enum

class PkgStatus(Enum):
    UP_TO_DATE = 'Already up to date'
    INSTALLED = 'Newly installed'
    NOT_FOUND = 'Not found'
    NOT_SURE = 'Could not determine'

class AptGet(dotbot.Plugin):
    _directive = 'aptget'

    def __init__(self, context):
        super(AptGet, self).__init__(self)
        self._context = context
        self._strings = {}
        self._strings[PkgStatus.UP_TO_DATE] = ["is already the newest", "ist bereits die neueste"]
        self._strings[PkgStatus.INSTALLED] = ["NEUEN Pakete werden installiert"]
        self._strings[PkgStatus.NOT_FOUND] = ["Unable to locate package", "kann nicht gefunden werden"]

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('AptGet cannot handle directive %s' %
                directive)
        return self._process_packages(data)

    def _process_packages(self, packages):
        defaults = self._context.defaults().get('aptget', {})
        results = {}
        successful = [PkgStatus.UP_TO_DATE, PkgStatus.INSTALLED]
        commandPrefix = ""

        if os.geteuid() != 0:
            commandPrefix = "sudo "

        success = True

        cleaned_packages = self._dispatch_names_and_sources(packages)
        if cleaned_packages['sources']:
            for source in cleaned_packages['sources']:
                success &= self._add_ppa(source, commandPrefix)

        # apt-get update
        success = self._update_index(commandPrefix)
        if not success:
            return success
        
        for pkg_name in cleaned_packages['packages']:
            result = self._install(pkg_name, commandPrefix)
            results[result] = results.get(result, 0) + 1 
            if result not in successful:
                self._log.error("Could not install package '{]}'".format(pkg_name))

        if all([result in successful for result in results.keys()]):
            self._log.info('All packages installed successfully')
            success = True
        else:
            sucess = False

        for status, amount in results.items():
            log = self._log.info if status in successful else self._log.error
            log('{} {}'.format(amount, status.value))

        return success

    def _add_ppa(self, source, commandPrefix):
        success = False
        if 'ppa:' not in source:
            source = 'ppa:%s' % source
        
        # NB: Trying to avoid subprocess.Popen(), as this command is pretty simple
        cmd = '{}add-apt-repository --yes {}'.format(commandPrefix, source)

        try:
            process = subprocess.Popen(cmd, shell=True,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT)
            out = process.stdout.read()
            process.stdout.close()
            self._log.info('Successfully added PPA "%s"' % source)
            success = True
        except subprocess.CalledProcessError as e:
            self._log.lowinfo('PPA "%s": %s' % (source, e.output))
            success = False
        except Exception as e:
            self._log.lowinfo('Failed to add PPA "%s": %s' % (source, e))
            success = False
        return success

    def _dispatch_names_and_sources(self, packages):
        '''
        Returns cleaned dict with list of sources and dict of packages.
        {"sources": [], "packages": {"packaga_name": "upgrade"}}
        '''
        cleaned_dict = {'sources': [], 'packages': []}
        if isinstance(packages, str):
            cleaned_dict['packages'].append(packages)
        elif isinstance(packages, list):
            for pkg_name in packages:
                cleaned_dict['packages'].append(pkg_name)
        elif isinstance(packages, dict):
            for pkg_name, pkg_opts in packages.items():
                cleaned_dict['packages'].append(pkg_name)
                if isinstance(pkg_opts, dict):
                    if 'ppa_source' in pkg_opts.keys():
                        cleaned_dict['sources'].append(pkg_opts['ppa_source'])
                else:
                    if pkg_opts:
                        cleaned_dict['sources'].append(pkg_opts)
        return cleaned_dict

    def  _update_index(self, commandPrefix):
        self._log.info("Updating APT package index")
        cmd = '{}apt-get update'.format(commandPrefix)

        try:
            process = subprocess.Popen(cmd, shell=True,
                                       stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT)
            out = process.stdout.read()
            process.stdout.close()
            self._log.info('APT package index updated successfully')
            return True
        except Exception as e:
            self._log.error('Failed to update index: {}'.format(e))
            return False

    def _install(self, pkg, commandPrefix):
        self._log.info("Installing package {}".format(pkg))
        cmd = '{}apt-get install {} -y'.format(commandPrefix, pkg)
        process = subprocess.Popen(cmd, shell=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)
        out = process.stdout.read()
        process.stdout.close()

        for item in self._strings.keys():
            for text in self._strings[item]:
                try:
                    index = out.find(text)
                except:
                    index = 0

                if index >= 0:
                    return item

        self._log.error("Could not determine what happened with package {}".format(pkg))
        return PkgStatus.NOT_SURE
    
