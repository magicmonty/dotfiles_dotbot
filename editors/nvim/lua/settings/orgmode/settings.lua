require('orgmode').setup({
  -- Set the path to the org-mode files
  org_agenda_files = "~/org",
  org_default_notes_file = "~/org/notes.org",
})

require('orgmode').setup_ts_grammar()
