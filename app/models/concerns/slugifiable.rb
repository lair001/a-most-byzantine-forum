module Slugifiable
  module InstanceMethods
    def slug
      begin
        return self.username.strip.downcase.gsub(' ', '-') unless self.username.nil?
      rescue NoMethodError
      end
      begin
        return self.title.strip.downcase.gsub(' ', '-') unless self.title.nil?
      rescue NoMethodError 
      end
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
