# `ls spec -R | grep 'spec/spec_helper'`.split(":\n").each do |directory|
#   $LOAD_PATH << directory
# end

ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
# require 'spec_helper'
require_all 'spec/spec_helper'

# include RoutesHelper
# include TitlesHelper
# include TaglinesHelper