Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/stylesheets"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/fonts"
#Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/fonts/iconic"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/javascripts"
Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /\.(eot|svg|ttf|woff)\z/
    true
  end
end
Rails.application.config.assets.precompile += %w( iconic/iconic_stroke.otf )
Rails.application.config.assets.precompile += %w( iconic/iconic_fill.otf )
