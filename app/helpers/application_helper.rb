# -*- coding: utf-8 -*-
module ApplicationHelper

  def active_link_class(path)
    current_page?(path) ? "active" : ""
  end

  def render_wiki(text)
    renderer = Redcarpet::Render::XHTML.new(with_toc_data: true)
    x = WorldWiki::WikiParser.new.parse(text).render
    y = DmStripper.strip(x, current_user)
    render_wiki_toc(text)
    Redcarpet::Markdown.new(renderer).render(y).html_safe
  end

  def render_wiki_toc(text)
    renderer = Redcarpet::Render::HTML_TOC.new
    toc = Redcarpet::Markdown.new(renderer).render(text)
    if toc.present?
      content_for(:sidebar) do
        content_tag("h4", "Table of Contents") + toc.html_safe
      end
    end
  end

  def locked_icon
    content_tag("i", "", :class => "icon-lock").html_safe
  end

end
