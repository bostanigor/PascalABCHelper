class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, uniqueness: true

  has_one :student, required: false, dependent: :destroy

  # Devise

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
