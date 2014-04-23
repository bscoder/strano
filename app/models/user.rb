class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  default_scope where(:deleted_at => nil)

  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end

  def to_s
    email
  end

end
