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
INSTALL_DIR = '$HOME/Library/LaunchAgents'
FULL_PLIST_PATH = "#{INSTALL_DIR}/#{PLIST_FILENAME}"

rule '.js' => '.coffee' do |t|
  File.open(t.name, 'w') do |name|
    name.print CoffeeScript.compile(File.read(t.source))
  end
end

desc 'Generate the launchd configuration file.'
task plist: [ SCRIPT_FILENAME, PLIST_TEMPLATE ] do
  File.open(PLIST_FILENAME, 'w') do |plist|
    label = "#{PLIST_PREFIX}.#{BASENAME}"
    arguments = %w[ osascript -l JavaScript ]
    arguments << "#{__dir__}/#{SCRIPT_FILENAME}"

    template = File.read(PLIST_TEMPLATE)
    content = ERB.new(template, nil, '-').result(binding)

    plist.print(content)
  end

  puts "Now, copy the generated plist file to your LaunchAgents directory and turn it on."
  puts
  puts "cp #{PLIST_FILENAME} #{INSTALL_DIR}"
  puts "launchctl load #{FULL_PLIST_PATH}"
end

task :uninstall do
  puts "Unload the plist from the system and remove the file."
  puts
  puts "launchctl unload #{FULL_PLIST_PATH}"
  puts "rm #{FULL_PLIST_PATH}"
end

desc 'Run the script.'
task run: SCRIPT_FILENAME do
  sh "osascript -l JavaScript #{SCRIPT_FILENAME}"
end

desc 'Print help instuctions.'
task :help do
  puts "Use `rake run` to compile & run the script."
  puts "Use `rake plist` compile, create the launchd configuration, and print installation instructions."
  puts "Use `rake uninstall` for uninstallation instructions."
end

task default: [ SCRIPT_FILENAME, :plist ]

CLEAN.include FileList['*.js']
CLEAN.include PLIST_FILENAME
