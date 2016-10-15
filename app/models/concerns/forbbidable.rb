module Forbiddable 
	module InstanceMethods 

		def absence_of_whitespace_in(attribute)
			errors.add(:base, "#{attribute} cannot contain whitespace.") if self.send(attribute).is_a?(String) && self.send(attribute).match(/[\t\f\v\n\r \u00A0…\u2003]/)
		end

		def absence_of_forbidden_characters_in(attribute)
			errors.add(:base, "#{attribute} cannot have forbidden characters.") if self.send(attribute).is_a?(String) && self.send(attribute).match(/[^\s!-ϿԱ-֏ἀ-῾\u2003₠-₾]+/)
		end

		def only_spaces_as_whitespace_in(attribute)
			errors.add(:base, "#{attribute} can only contain spaces as whitespace.") if self.send(attribute).is_a?(String) && self.send(attribute).match(/[\t\f\v\n\r\u00A0…\u2003]/)
		end

	end
end