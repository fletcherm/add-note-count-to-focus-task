require 'rake/clean'
require 'rubygems'
require 'bundler/setup'
Bundler.require

SCRIPT_FILENAME = 'add-note-count-to-focus-task.js'

rule '.js' => '.coffee' do |t|
  File.open(t.name, 'w') do |name|
    name.print CoffeeScript.compile(File.read(t.source))
  end
end

desc 'Run the script.'
task run: SCRIPT_FILENAME do
  sh "osascript -l JavaScript #{SCRIPT_FILENAME}"
end

task default: :run

CLEAN.include FileList['*.js']
