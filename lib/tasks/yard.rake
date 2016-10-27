# frozen_string_literal: true
require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = []
  t.options << '--debug' << '--verbose' if $trace
end
