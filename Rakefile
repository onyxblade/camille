# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec_environments

task :spec_environments do
  ENV['RAILS_ENV'] = 'test'
  Rake::Task[:spec].invoke

  ENV['RAILS_ENV'] = 'development'
  Rake::Task[:spec].reenable
  Rake::Task[:spec].invoke
end
