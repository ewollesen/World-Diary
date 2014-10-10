require "test_helper"

class ApplicationHelperTest < ActionView::TestCase

  def setup
    @dm = User.new(dm: true)
    @pc = User.new
    @subject = Subject.new
  end

  def test_render_wiki_smoke
    assert_equal "<p>foo</p>", render_wiki("foo", @pc, @subject).strip
  end

  def test_render_wiki_dice_roller
    assert_equal "<p><span class=\"dm\" data-mod=\"0\" data-rolls=\"1\" data-sides=\"20\">d20</span></p>\n",
                 render_wiki("{d20}", @dm, @subject)
  end

  def test_render_wiki_ampersand_in_text
    text = "Dungeons & Dragons"
    assert_equal "<p>Dungeons &amp; Dragons</p>",
                 render_wiki(text, @user, @subject).strip
    text = "Dungeons &amp; Dragons"
    assert_equal "<p>#{text}</p>",
                 render_wiki(text, @user, @subject).strip
  end

  def test_render_wiki_blockquote_in_list
    text = "* Foo\n\n  > block quote"
    assert_equal Kramdown::Document.new(text).to_html.html_safe,
                 render_wiki(text, @user, @subject)
  end

end
