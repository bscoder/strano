class TasksController < InheritedResources::Base

  belongs_to :project
  before_filter :authenticate_user!
  before_filter :current_user_is_admin, :only => [:new, :create]

  actions :new, :create

  def new
    @task = parent.tasks.build params[:task]
    new!
  end

  def create
    @task = parent.tasks.build params[:task]
    @task.author = current_user
    create!
  end
  
end

