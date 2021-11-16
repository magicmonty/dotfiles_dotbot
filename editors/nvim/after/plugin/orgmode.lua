local setup,orgmode = pcall(require, "orgmode")
if not setup then return end

orgmode.setup({
  -- Set the path to the org-mode files
  org_agenda_files = "~/org",
  org_default_notes_file = "~/org/notes.org",
})
