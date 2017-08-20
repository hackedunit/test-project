require 'github_changelog_generator/task'
require 'chandler/tasks'

GitHubChangelogGenerator::RakeTask.new :changelog do |config| end

namespace :release do
  desc 'Bump version number'
  task :autoversion, [:version_type] do |t, args|
    if(['patch','minor','major'].include? args[:version_type])
      puts '[1/4] Bumping version number...'
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
    puts '[2/4] Generating changelog...'
    Rake::Task['changelog'].invoke
    `git commit -a -m 'Updated Changelog'`
    `git push`
  end

  desc 'Update release notes at Github'
  task :release_notes do
    puts '[3/4] Updating release notes at Github...'
    `bundle exec chandler push`
  end

  desc 'Upload artifacts to Github'
  task :upload_artifacts do
    puts '[4/4] Uploading artifacts to Github'
    # `bundle exec jekyll build`
    current_version = instance_eval(File.read './version.rb')
    file_name = "/tmp/test-project-#{current_version}.zip"
    Dir.chdir('assets/') do
      `zip -r -X #{file_name} .`
    end
    `ghr #{current_version} #{file_name}`
    `rm #{file_name}`
  end
end

desc 'Release Test-Project'
task :release, [:version_type] do |t, args|
  STDOUT.puts "Are you sure you want to create a new #{args[:version_type]} release? (y/n)"
  input = STDIN.gets.strip
  if input == 'y'
    Rake::Task['release:autoversion'].invoke(args[:version_type])
    Rake::Task['release:changelog'].invoke
    Rake::Task['release:release_notes'].invoke
    Rake::Task['release:upload_artifacts'].invoke
    puts "Released #{args[:version_type]} version for Test-Project successfully!"
  end
end
