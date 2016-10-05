class User < Sinatra::Base

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

end