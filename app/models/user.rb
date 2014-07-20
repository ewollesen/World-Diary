class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :first_user_is_admin

  has_many :veil_passes, :dependent => :destroy


  def self.pcs
    where(:dm => false)
  end

  def short_name
    first_name + " " + last_name[0..0]
  end

  def name
    first_name + " " + last_name
  end

  private

  def first_user_is_admin
    self.dm = true if User.count.zero?
  end
end
