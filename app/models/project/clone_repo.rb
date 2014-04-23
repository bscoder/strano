class Project
  class CloneRepo

    def self.perform(project_id)
      begin
        project = Project.find(project_id)
      rescue ActiveRecord::RecordNotFound
        return
      end

      Strano::Repo.clone project.url

      Project.update_all({:updated_at => Time.now,
                          :cloned_at => Time.now,
                          :pulled_at => Time.now,
                          :pull_in_progress => false},
                          :id => project_id)
    end
  end
end
