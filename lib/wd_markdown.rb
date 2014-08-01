module WdMarkdown

  def self.render(text)
    @xhtml ||= Redcarpet::Render::XHTML.new(with_toc_data: true)
    @markdown ||= Redcarpet::Markdown.new(@xhtml, footnotes: true, quote: true)
    @markdown.render(text).html_safe
  end

end
