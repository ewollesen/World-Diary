class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name

  before_create :first_user_is_admin

  has_many :veil_passes, :dependent => :destroy


  def self.pcs
    where(:dm => false)
  end


  def name
    first_name + " " + last_name
  end


  private

  def first_user_is_admin
    self.dm = true if User.count.zero?
  end
end
