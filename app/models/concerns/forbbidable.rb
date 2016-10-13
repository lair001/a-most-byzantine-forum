module Forbiddable 
	module InstanceMethods 

		def absence_of_forbidden_characters(attribute)
			errors.add(:base, "#{attribute} cannot have forbidden characters.") if self.send(attribute).is_a?(String) && self.send(attribute).match(/[^\s!-ϿԱ-֏ἀ-῾₠-₾]+/)
		end

	end
end