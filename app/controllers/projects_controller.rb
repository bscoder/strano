class ProjectsController < InheritedResources::Base

  before_filter :authenticate_user!
  before_filter :pull_repo, :only => [:show, :edit]

  respond_to :json, :only => :show
  custom_actions :resource => :pull

  def show
    show! do
      @recent_tasks = resource.tasks.order(:name)
    end
  end

  def pull
    resource.pull!
    redirect_to resource, :notice => "Local repository is being updated..."
  end

  def destory
    destroy! { root_url(:anchor => "projects") }
  end


  private

    def pull_repo
      resource.pull
    end

end
