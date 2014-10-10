require "test_helper"

class XmlParserTest < Minitest::Test

  def test_parse_mangles_entities
    assert_equal "Dungeons &amp; Dragons",
                 XmlParser.parse("Dungeons &amp; Dragons").to_xml
  end

  def test_parse_mangles_unescaped_ampersands
    assert_equal "Dungeons  Dragons",
                 XmlParser.parse("Dungeons & Dragons").to_xml
  end

  def test_parse_does_not_strip_entities
    assert_equal "Dungeons &amp; Dragons",
                 XmlParser.parse("Dungeons &amp; Dragons").to_xml
  end

end
