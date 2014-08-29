module NoteInserter
  extend ActionView::Helpers::TagHelper

  NOTE_RE = /\{note:\s*(.+)\}/

  def self.parse(text)
    text.gsub(NOTE_RE) do |matched_text|
      name = $1
      note = Note.where(permalink: name).first
      content_tag("note", content_tag("h4", note.name) + note.text)
    end
  end

end
