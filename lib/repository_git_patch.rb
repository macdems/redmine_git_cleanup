require_dependency 'repository/git'

module RepositoryGitPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :fetch_changesets, :cleanup
    end
  end

  module InstanceMethods

    def fetch_changesets_with_cleanup
      fetch_changesets_without_cleanup

      cl = changesets.map { |c| c if extra_info['heads'].include? c.revision }.compact
      cs = changesets.to_set - cl.to_set
      cl.each do |c|
        c.parents.each do |p|
          if cs.include? p
            cl.append p
            cs.delete p
          end
        end
      end
      cs.each do |c|
        c.destroy
        Rails.logger.info "Deleted orphaned revision #{c.revision} from #{project.identifier}/#{identifier}"
      end
      save
    end

  end

end
