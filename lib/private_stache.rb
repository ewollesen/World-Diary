module PrivateStache

  class Renderer
    def initialize(has_vp, is_dm)
      @has_vp = has_vp
      @is_dm = is_dm
    end

    def classes(base, tag_name)
      [
        base.to_s,
        tag_name.to_s == "div" ? "alert" : "",
      ].compact.join(" ").strip
    end

    def render_tag(text, base)
      html = Mustache.render(text, {dm: @is_dm, vp: @has_vp})
      tag_name = /\n/ === html ? "div" : "span"

      send(tag_name, html, base)
    end

    def div(html, base)
      "\n<div markdown=\"1\" class=\"#{classes(base, "div")}\">\n#{html}\n</div>\n"
    end

    def span(html, base)
      "<span markdown=\"1\" class=\"#{classes(base, "span")}\">#{html}</span>"
    end

    def dm(text)
      if @is_dm
        render_tag(text, :dm)
      else
        ""
      end
    end

    def vp(text)
      if @is_dm || @has_vp
        render_tag(text, :vp)
      else
        ""
      end
    end

  end

  def self.render(text, has_vp, is_dm)
    Mustache.render(text, Renderer.new(has_vp, is_dm))
  end

end
