require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'rake/clean'
require 'erb'

BASENAME = "add-note-count-to-focus-task"
SCRIPT_FILENAME = "#{BASENAME}.js"

PLIST_PREFIX = 'com.skeletor'
PLIST_FILENAME = "#{PLIST_PREFIX}.#{BASENAME}.plist"
PLIST_TEMPLATE = "#{PLIST_FILENAME}.erb"

rule '.js' => '.coffee' do |t|
  File.open(t.name, 'w') do |name|
    name.print CoffeeScript.compile(File.read(t.source))
  end
end

desc 'Generate the LaunchAgent plist file'
task plist: [ SCRIPT_FILENAME, PLIST_TEMPLATE ] do
  File.open(PLIST_FILENAME, 'w') do |plist|
    label = "#{PLIST_PREFIX}.#{BASENAME}"
    arguments = %w[ osascript -l JavaScript ]
    arguments << "/Users/fletcher/git/#{BASENAME}/#{SCRIPT_FILENAME}"

    template = File.read(PLIST_TEMPLATE)
    content = ERB.new(template, nil, '-').result(binding)

    plist.print(content)
  end

  puts "Now, copy the generated plist file to your LaunchAgents directory and turn it on."
  puts
  puts "cp #{PLIST_FILENAME} $HOME/Library/LaunchAgents"
  puts "launchctl load $HOME/Library/LaunchAgents/#{PLIST_FILENAME}"
end

desc 'Run the script.'
task run: SCRIPT_FILENAME do
  sh "osascript -l JavaScript #{SCRIPT_FILENAME}"
end

task :default do
  puts "Sadly, there's no good default here."
  puts "Use `rake run` to compile & run the script."
  puts "Use `rake plist` to create the launchd plist and print installation instructions."
end

CLEAN.include FileList['*.js']
CLEAN.include PLIST_FILENAME
