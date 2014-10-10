module WdMarkdown

  def self.render(text)
    render_kramdown(text)
  end


  private

  def self.toc
    "\n^\n* Table of Contents\n{:toc}"
  end

  def self.render_kramdown(text)
    Kramdown::Document.new(text + toc).to_html.html_safe
  end

  def self.render_redcarpet(text)
    @xhtml ||= Redcarpet::Render::XHTML.new(with_toc_data: true)
    @markdown ||= Redcarpet::Markdown.new(@xhtml, footnotes: true, quote: true)
    @markdown.render(text).html_safe
  end

end
