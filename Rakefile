require './winnie'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

desc "Generates report"
task :generate do |task, args|
  ARGV.each { |a| task a.to_sym do; end }

  winnie = Winnie.new(
    File.join(File.dirname(__FILE__), '/data/pollens.csv'),
    File.join(File.dirname(__FILE__), '/data/harvest.csv'),
  )

  winnie.output((ARGV[1] || :plain).to_sym)
end

task default: :generate
