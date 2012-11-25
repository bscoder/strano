require 'kernel'
require 'open3'

class Job < ActiveRecord::Base
  include Ansible

  belongs_to :project
  belongs_to :user
  belongs_to :task
  after_create :execute_task

  default_scope order('created_at DESC')
  default_scope where(:deleted_at => nil)

  validate :precense => :task

  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end

  def run_task
    success = true

    ARGV << stage if stage

    FileUtils.chdir project.repo.path do
      out, status = Open3.capture2e(task.name)

      puts out

      success = status.success?
    end

    !!success
  end

  def complete?
    !completed_at.nil?
  end

  def command
    "#{stage} #{task}"
  end

  def puts(msg)
    update_attribute :results, (results_before_type_cast || '') + msg unless msg.blank?
  end

  def results
    unless (res = read_attribute(:results)).blank?
      escape_to_html res
    end
  end


  private

    def full_command
      %W(-f #{Rails.root.join('Capfile.repos')} -f Capfile -Xx#{verbosity}) + branch_setting + command.split(' ')
    end

    def branch_setting
      %W(-s branch=#{branch}) unless branch.blank?
    end

    def execute_task
      CapExecute.perform_async id
    end

end
