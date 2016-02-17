# ['models'].each do |path_part|
#   current_path = File.expand_path('..', __FILE__)
#   directories = "#{current_path}#{path_part}/**/"
#   Dir.glob(directories).each {|dir| $:.push(dir)}
#   files = "#{directories}/*.rb"
#   Dir.glob(files).each {|file| require_relative file}
# end

current_path = File.expand_path('..', __FILE__)
$: << "#{current_path}/models"

require 'customer_request'
require 'insurer_coverage'
require 'quote'
require 'quote_builder'