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

  def attachment_metadata(attachment)
    bits = []

    content_tag("span", :class => "muted") do
      if attachment.file_size
        bits << number_to_human_size(attachment.file_size)
      end

      if attachment.width && attachment.height
        bits << "#{attachment.width}&times;#{attachment.height}"
      end

      if attachment.content_type
        bits << attachment.content_type
      end

      bits.join(", ").html_safe
    end

  end

end
