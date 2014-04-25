require 'kernel'
require 'open3'

class Job < ActiveRecord::Base
  include Ansible

  belongs_to :project
  belongs_to :user
  belongs_to :task

  default_scope order('created_at DESC')
  default_scope where(:deleted_at => nil, :visible => true)

  validate :precense => :task, :if => :visible

  after_create :perform_delay

  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end

  def perform_delay
    self.delay.perform
  end

  def perform
    Rails.logger.info "Performing Job #{id}"
    Project::PullRepo.perform(project_id) unless project.pull_in_progress?
    success = true

    FileUtils.chdir project.repo.path do
      Bundler.with_clean_env do
        Open3.popen2e({}, command) do |input, output_and_error, wait_thread|
          input.close
          while !output_and_error.eof?
            msg = output_and_error.readline
            update_attribute :results, (results_before_type_cast || '') + msg unless msg.blank?
          end

          success = wait_thread.value.success?
        end
      end
    end
    update_attributes :completed_at => Time.now, :success => success
  end

  def complete?
    !completed_at.nil?
  end

  def results
    unless (res = read_attribute(:results)).blank?
      escape_to_html(ERB::Util.html_escape(res))
    end
  end

  def command
    if task.with_argument?
      task.name.sub(Task::ARG_PLACEHOLDER, notes)
    else
      task.name
    end
  end

end
