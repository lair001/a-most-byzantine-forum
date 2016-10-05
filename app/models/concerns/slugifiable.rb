module Slugifiable
  module InstanceMethods
    def slug
      return self.username.strip.downcase.gsub(' ', '-') if self.class == User
      return self.title.strip.downcase.gsub(' ', '-') if self.class == Thread
      nil
    end
  end
  module ClassMethods
    def find_by_slug(slug)
      self.all.each do |instance|
        return instance if instance.slug == slug
      end
      nil
    end
  end
end