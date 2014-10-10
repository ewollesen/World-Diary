module Convert

  Subject.find_each do |s|
    # This will lose classes on dm / vp tags, but it'll have to do.
    converted = s.text.gsub(/\<((\/?)(dm|vp))[^\>]*\>/) do |matched|
      prefix = "/" == $1 ? "/" : "#"
      "{{#{prefix}#{$2}}}"
    end.gsub(%r[\{\{(?!/)], "{{#")
    s.update_attribute(:text, converted)

    # due to difficulties with edge cases, I've decided not to try to modify
    # links
  end

end
