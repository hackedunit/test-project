require 'github_changelog_generator/task'
require 'chandler/tasks'

GitHubChangelogGenerator::RakeTask.new :changelog do |config| end

namespace :release do
  desc 'Bump version number'
  task :autoversion, [:version_type] do |t, args|
    if(['patch','minor','major'].include? args[:version_type])
      puts '[1/3] Bumping version number...'
      `bundle exec autoversion #{args[:version_type]} --force`
      `git push`
      `git push --tags`
    else
      puts 'Version type required: patch, minor, major'
      exit
    end
  end

  desc 'Generate changelog'
  task :changelog do
    puts '[2/3] Generating changelog...'
    Rake::Task['changelog'].invoke
    `git commit -a -m 'Updated Changelog'`
    `git push`
  end

  desc 'Update release notes at Github'
  task :release_notes do
    puts '[3/3] Updating release notes at Github...'
    `bundle exec rake chandler:push`
  end
end

desc 'Release OnApp-Design'
task :release, [:version_type] do |t, args|
  STDOUT.puts "Are you sure you want to create a new #{args[:version_type]} release? (y/n)"
  input = STDIN.gets.strip
  if input == 'y'
    Rake::Task['release:autoversion'].invoke(args[:version_type])
    Rake::Task['release:changelog'].invoke
    Rake::Task['release:release_notes'].invoke
    puts "Released #{args[:version_type]} version for OnApp-Design successfully!"
  end
end
