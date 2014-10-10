require "test_helper"

class SubjectTest < ActiveSupport::TestCase

  def subject
    @subject ||= Subject.new(name: "Foo", text: "Test Subject")
  end

  def test_text_remains_unescaped
    subject.text = "D&D"

    subject.save

    assert subject.text = "D&D"
  end

  def test_vp_text_remains_unescaped
    subject.text = "D&D"

    subject.save

    assert subject.vp_text = "D&D"
  end

  def test_anon_text_remains_unescaped
    subject.text = "D&D"

    subject.save

    assert subject.anon_text = "D&D"
  end

  def test_text_with_links_remains_unescaped
    subject.text = "D&D <a href=\"#\">with a link</a>"

    subject.save

    assert subject.text = "D&D <href=\"#\">with a link</a>"
  end


end
