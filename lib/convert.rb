module Convert

  Subject.find_each do |s|
    # This will lose classes on dm / vp tags, but it'll have to do.
    s.update_attribute(:text, s.text.gsub(/\<(\/?(dm|vp))[^\>]*\>/, "{{\\1}}"))

    # due to difficulties with edge cases, I've decided not to try to modify links
    # s.update_attribute(:text, s.text.gsub(/([^\]]|^)\[([^^][^\]\n\t\r]+)\](?![:\[\(])/, "\\1[[\\2]]"))
  end

end
