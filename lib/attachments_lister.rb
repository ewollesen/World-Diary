module AttachmentsLister

  ATTACH_RE = /\{attachments_list\}/


  def self.parse(text, attachments)
    att = attachments

    ret = text.gsub(ATTACH_RE) do |t|
      att = []
      list_of_attachments(attachments)
    end

    [ret, att]
  end


  private

  def self.list_of_attachments(attachments)
    attachments.sort_by {|a| a.caption}.map do |attachment|
      t = <<EOF
#### #{attachment.caption}

![#{attachment.caption}](#{attachment.attachment.url})
EOF
    end.join("\n")
  end

end
