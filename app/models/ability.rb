class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, :all
    else
      can :edit,    Project, :id => user.owned_projects.map(&:id)
      can :manage,  Task,    :project => {:id => user.owned_projects.map(&:id)}
      can :execute, Task,    :id => user.tasks.map(&:id)
    end
  end
end
