# -*- coding: utf-8 -*-
module ApplicationHelper

  def title
    if content_for?(:title)
      content_for(:title) + " : World Diary"
    else
      "World Diary"
    end
  end

  def active_link_class(path)
    current_page?(path) ? "active" : ""
  end

  def context_icon(subject)
    user = current_user || User.new

    if user.dm?
      context_icon_dm(subject)
    else
      context_icon_user(subject, user)
    end
  end

  def render_wiki(text)
    renderer = Redcarpet::Render::XHTML.new(with_toc_data: true)
    x = WorldWiki::WikiParser.new.parse(text).render
    y = DmStripper.strip(x, current_user, @subject.authorized_users.include?(current_user))
    render_wiki_toc(text)
    Redcarpet::Markdown.new(renderer).render(y).html_safe
  end

  def render_wiki_toc(text)
    renderer = Redcarpet::Render::HTML_TOC.new
    toc = Redcarpet::Markdown.new(renderer).render(text)
    if toc.present?
      content_for(:sidebar) do
        content_tag("h4") do
          content_tag("i", "", class: "icon-list-ul") + " " +
                      "Table of Contents ".html_safe
        end + toc.html_safe
      end
    end
  end

  def locked_icon
    content_tag("i", "", :class => "icon-lock").html_safe
  end

  def unlocked_icon
    content_tag("abbr", title: "You have a veil pass for this subject.") do
      content_tag("i", "", :class => "icon-unlock").html_safe
    end
  end

  def attachment_metadata(attachment)
    bits = []

    content_tag("small", :class => "muted") do
      if attachment.file_size
        bits << number_to_human_size(attachment.file_size)
      end

      if attachment.content_type
        bits << attachment.content_type
      end

      if attachment.width && attachment.height
        bits << "#{attachment.width}&times;#{attachment.height}"
      end

      bits.join(", ").html_safe
    end
  end

  def attachment_image_overlay(attachment, &block)
    if attachment.dm_only
      attachment_image_overlay_inner(attachment, &block)
    else
      capture {yield}
    end
  end


  private

  def attachment_image_overlay_inner(attachment, &block)
    content_tag(:div, :class => "attachment-overlay-dm-only") do
      capture {yield} +
        content_tag(:div, context_icon(attachment), :class => "overlay-icons")
    end
  end

  def context_icon_dm(subject)
    html = ""
    noun = subject.is_a?(Attachment) ? "attachment" : "subject"

    if subject.dm_only?
      html << content_tag("i", "", :class => "icon-lock") + " "
    end
    if subject.authorized_users.present?
      html << content_tag("abbr", title: "Veil passes exist for this #{noun}.", rel: "tooltip") do
        content_tag("i", "", :class => "icon-key")
      end
    end

    html.html_safe
  end

  def context_icon_user(subject, user)
    noun = subject.is_a?(Attachment) ? "attachment" : "subject"

    if subject.authorized_user?(user)
      content_tag("abbr", rel: "tooltip", title: "You have a veil pass for this #{noun}.") do
        content_tag("i", "", :class => "icon-key")
      end
    end
  end

end
