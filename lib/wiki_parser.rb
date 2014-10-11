module WikiParser
  WIKI_LINK_RE = %r{\[\[([^\]\|]+)(?:\|([^\]]+))?\]\]}


  def self.render(text)
    text.gsub(WIKI_LINK_RE) do |match|
      url = Subject.url_for($1)
      text = $2 || $1
      "[#{text.strip}](#{url.strip})"
    end
  end

end
