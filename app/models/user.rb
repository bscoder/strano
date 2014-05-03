class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :is_admin, :project_ids, :owned_project_ids

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks

  has_many :owned_projects, :class_name => "Project", :foreign_key => :owner_id

  default_scope where(:deleted_at => nil)

  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end

  def to_s
    email
  end

end
