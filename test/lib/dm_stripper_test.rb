require "test_helper"

class DmStripperTest < Minitest::Test

  def setup
    @dm = User.new(dm: true)
    @pc = User.new
    @subject = Subject.new
  end


  def test_strip_smoke
    assert_equal "foo", DmStripper.strip("foo", @pc, @subject)
  end

  def test_strip_does_not_strip_ampersands
    markdown = WdMarkdown.render("Dungeons & Dragons")
    assert_equal markdown,
                 DmStripper.strip(markdown, @pc, @subject)

    markdown = WdMarkdown.render("D&D")
    assert_equal markdown,
                 DmStripper.strip(markdown, @pc, @subject)
  end

  def test_strip_does_not_strip_html
    text = "Dungeons <a href=\"#\">and</a> Dragons"
    assert_equal text, DmStripper.strip(text, @pc, @subject)
  end

end
