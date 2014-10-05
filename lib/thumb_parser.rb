module ThumbParser

  def self.parse(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      process_thumbs(doc)
    end.to_xml
  end


  private

  def self.process_thumbs(doc)
    (doc/"thumb").each do |thumb|
      href = thumb["href"] || thumb["src"]
      template = <<EOF
<div class="pull-right col-md-5 col-lg-4">
  <div class="thumbnail">
    <a href="#{href}">
      <img src="#{thumb["src"]}" alt="#{thumb["alt"]}" class="img-responsive"/>
    </a>
    <div class="caption text-center">
      <p>
        <a href="#{href}">#{thumb["alt"]}</a>
      </p>
    </div>
  </div>
</div>
EOF
      thumb.swap(template)
    end
  end

  # <div class="pull-right col-md-6 col-lg-5">
  #   <div class="thumbnail">
  #     <img src="https://wd.xmtp.net/uploads/attachment/attachment/17/noble_by_beaver_skin-d71v98g.jpg" alt="Morlen Findley" class="img-responsive"/>
  #     <div class="caption">
  #       <p>Sheriff Morlen Findley</p>
  #     </div>
  #   </div>
  # </div>

end
