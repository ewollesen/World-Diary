require "test_helper"

class PrivateStacheTest < ActiveSupport::TestCase

  def render_dm(text)
    PrivateStache.render(text, true, true)
  end

  def render_vp(text)
    PrivateStache.render(text, true, false)
  end

  def render_anon(text)
    PrivateStache.render(text, false, false)
  end

  def test_render_dm_tag
    text = "{{#dm}}You can't see me{{/dm}}"
    assert_equal "", render_anon(text)
    assert_equal "", render_vp(text)
    assert_equal "<span markdown=\"1\" class=\"dm\">You can't see me</span>",
                 render_dm(text)
  end

  def test_render_vp_tag
    text = "{{#vp}}You can't see me{{/vp}}"
    assert_equal "", render_anon(text)
    assert_equal "<span markdown=\"1\" class=\"vp\">You can't see me</span>",
                 render_vp(text)
    assert_equal "<span markdown=\"1\" class=\"vp\">You can't see me</span>",
                 render_dm(text)
  end

  def test_render_dm_para
    text = <<EOF
{{#dm}}
This is text that only a DM should be able to see.

Player's can't see it.
{{/dm}}

Player's can see this
EOF
    expected_dm = <<EOF

<div markdown="1" class="dm alert">
This is text that only a DM should be able to see.

Player's can't see it.

</div>

Player's can see this
EOF
    assert_equal "\nPlayer's can see this\n", render_anon(text)
    assert_equal "\nPlayer's can see this\n", render_vp(text)
    assert_equal expected_dm, render_dm(text)
  end

end
