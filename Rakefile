# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

spec_gem_task = RSpec::Core::RakeTask.new(:spec_gem)
spec_gem_task.exclude_pattern = 'spec/camille/rails/*_spec.rb'

spec_rails_task = RSpec::Core::RakeTask.new(:spec_rails)
spec_rails_task.pattern = 'spec/camille/rails/*_spec.rb'

task default: :spec

task :spec do
  Rake::Task[:spec_gem].invoke

  ENV['RAILS_ENV'] = 'test'
  Rake::Task[:spec_rails].invoke

  ENV['RAILS_ENV'] = 'development'
  Rake::Task[:spec_rails].reenable
  Rake::Task[:spec_rails].invoke
end
