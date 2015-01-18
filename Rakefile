#!/usr/bin/env rake
require 'rubocop/rake_task'

namespace :test do
  RuboCop::RakeTask.new(:rubocop)

  task all: :rubocop
end

task default: 'test:all'
