desc "Generate TAGS file"
task :ctags do
  %x{
ctags -f TAGS \
      --extra=-f \
      --languages=-javascript \
      --exclude=.git \
      --exclude=log \
      --exclude=tmp \
      -e \
      -R . \
      $(rbenv prefix)/lib/ruby/gems/2.1.0/gems
}
end
