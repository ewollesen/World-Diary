module PrivateStache

  def self.render(text, has_vp, is_dm)
    Mustache.render(text, {vp: has_vp || is_dm, dm: is_dm})
  end

end
