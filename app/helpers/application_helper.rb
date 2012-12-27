# -*- coding: utf-8 -*-
module ApplicationHelper

  def active_link_class(path)
    current_page?(path) ? "active" : ""
  end

  def render_wiki(text)
    x = WorldWiki::WikiParser.new.parse(text).render
    Redcarpet::Markdown.new(Redcarpet::Render::XHTML).render(x).html_safe
  end

  def locked_icon
    content_tag("i", "", :class => "icon-lock").html_safe
  end
end
