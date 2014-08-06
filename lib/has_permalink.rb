module HasPermalink

  module IncludedMethods
    def generate_permalink
      candidate = name.parameterize

      if self.class.exists?(:permalink => candidate)
        candidate += "-2"
        while self.class.exists?(:permalink => candidate)
          candidate.next!
        end
      end

      candidate
    rescue StandardError
      Rails.logger.debug("Failed to generate permalink for name: %p" % [name])
      nil
    end

    def permalink
      read_attribute(:permalink) || self.permalink = generate_permalink
    end

  end


  module ClassMethods
    def has_permalink
      send(:include, IncludedMethods)
      before_validation(:on => :create) do
        self.permalink = generate_permalink unless self.permalink.present?
      end
    end
  end


  def self.included(base)
    base.extend(ClassMethods)
  end

end


ActiveRecord::Base.send(:include, HasPermalink)
