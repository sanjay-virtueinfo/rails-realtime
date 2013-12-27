class User < ActiveRecord::Base
  # attr_accessible :title, :body
  SUPER_ADMIN = "SuperAdmin"
  USER = "User"

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.login_field = 'email'
  end


  attr_writer :password_required

  validates :email, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_presence_of :password, :if => :password_required?

  has_one :user_role, :dependent => :destroy
  has_one :role, :through => :user_role

  def password_required?
    @password_required
  end

  validates_uniqueness_of :email
  validates :email, :first_name, :last_name, :term, :presence => true

  def is_admin?
    has_role?(SUPER_ADMIN)
  end

  def is_user?
   has_role?(USER)
  end

  def fullname
    "#{first_name} #{last_name}"
  end

end
