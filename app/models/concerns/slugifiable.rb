module Slugifiable

  module InstanceMethods

    def slug
      return self.username.strip.downcase.gsub(' ', '-') if self.class.attribute_method?(:username) && !self.username.nil?
      return self.title.strip.downcase.gsub(' ', '-') if self.class.attribute_method?(:title) && !self.title.nil?
      nil
    end

    def presence_of_unique_slug
      if self.slug.nil?
        errors.add(:base, 'Must have a slug.')
      elsif !self.class.validate_by_slug(self) 
        errors.add(:base, 'Must have a unique slug.')
      end
    end

  end

  module ClassMethods

    def find_by_slug(slug)
      self.all.each do |instance|
        return instance if instance.slug == slug
      end
      nil
    end

    def validate_by_slug(object)
      return false if object.class != self || object.slug.nil? || object.slug.match(/[^-]/).nil?
      self.all.each do |instance|
        return false if instance.slug == object.slug && instance != object
      end
      true
    end

  end

end
