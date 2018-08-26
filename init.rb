require 'redmine'

Redmine::Plugin.register :redmine_git_cleanup do
  name 'Redmine GIT cleanup plugin'
  author 'Maciek Dems'
  author_url 'https://github.com/macdems'
  description 'This Plugin removes orphaned revisions from GIT repo'
  version '0.0.1'
  url 'https://github.com/macdems/redmine_git_cleanup'
  #requires_redmine :version_or_higher => '2.5.0'
end

Rails.configuration.to_prepare do
  Repository::Git.send(:include, RepositoryGitPatch)
end
