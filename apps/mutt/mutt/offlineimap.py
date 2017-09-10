#!/usr/bin/python
import re, subprocess

### taken from http://stevelosh.com/blog/2012/10/the-homely-mutt/#installing-offlineimap

def get_keychain_pass(account=None, server=None):
    params = {
        'security': '/usr/bin/security',
        'command': 'find-generic-password',
        'account': account,
        'server': server,
        'keychain': '~/Library/Keychains/login.keychain',
    }
    command = "sudo -u martingondermann %(security)s -v %(command)s -g -a %(account)s -s %(server)s %(keychain)s" % params
    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    outtext = [l for l in output.splitlines()
               if l.startswith('password: ')][0]

    return re.match(r'password: "(.*)"', outtext).group(1)

if __name__ == '__main__':
    import sys
    account = sys.argv[1]
    server = sys.argv[2]
    print get_keychain_pass(account, server)
