#require 'capistrano/cli'
#require 'capistrano_monkey/configuration/namespaces'

class Project < ActiveRecord::Base

  has_many :jobs,  :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_one :job_in_progress, :class_name => "Job"

  validate :url, :presence => true, :uniqueness => { :case_sensitive => false }

  after_create :clone_repo
  after_destroy :remove_repo

  # Lets do some delegation so that we can access some common methods directly.
  delegate :user_name, :repo_name, :cloned?, :capified?, :to => :repo

  default_scope where(:deleted_at => nil)


  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end

  def to_s
    "#{user_name}/#{repo_name}"
  end

  # Returns a Boolean true if this project has a job in progress.
  def job_in_progress?
    !job_in_progress_id.nil?
  end

  # Is this project part of a Github organization profile?
  #
  # Has this project completed cloning?
  #
  # Returns a Boolean true if it has been cloned.
  def cloned?
    !cloned_at.blank?
  end

  # Does the given user have access to this project's repository?
  #
  # user - The current_user User object.
  #
  # Returns a Boolean true if the user has access.
  def accessible_by?(user)
    true
  end

  # Returns a Strano::Repo instance.
  def repo
    @repo ||= Strano::Repo.new(url)
  end

  # Returns a Strano::Repo instance of the repository referenced in the Capistrano file.
  def target_repo
    @target_repo = Strano::Repo.new(cap.repository)
  end

  # The public task list for this project's repository.
  #
  # Returns an Array of tasks.
  def public_tasks
    @public_tasks ||= tasks.reject { |t| t.description.empty? || t.description =~ /^\[internal\]/ }
  end

  # Run git pull on the repo, as long as the last pull was more than 15 mins ago.
  def pull
    if !pull_in_progress? && !pulled_at.nil? && (Time.now - pulled_at) > 900
      PullRepo.delay.perform(id)
    end
  end

  # Run git pull on the repo regardless of when it was last pulled.
  def pull!
    PullRepo.delay.perform(id)
  end

  private

    def clone_repo
      CloneRepo.delay.perform(id)
    end

    def remove_repo
      RemoveRepo.delay.perform(id)
    end

end
