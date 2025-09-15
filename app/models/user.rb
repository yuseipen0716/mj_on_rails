# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  name            :string(50)       not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  unique_id       :string(20)       not null
#
# Indexes
#
#  index_users_on_email      (email) UNIQUE WHERE email IS NOT NULL
#  index_users_on_unique_id  (unique_id) UNIQUE
#
class User < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :games, through: :players
  has_many :game_events, through: :players

  validates :unique_id, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :name, length: { maximum: 50 }

  # パスワード認証（オプション機能として）
  has_secure_password validations: false
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  before_validation :generate_unique_id, on: :create
  before_create :set_default_name

  private

  def generate_unique_id
    return if unique_id.present?

    loop do
      candidate = generate_random_id
      unless User.exists?(unique_id: candidate)
        self.unique_id = candidate
        break
      end
    end
  end

  def generate_random_id
    # 約3.4兆パターン
    "#{SecureRandom.alphanumeric(6).upcase}#{rand(1000..9999)}"
  end

  def set_default_name
    self.name = "プレイヤー#{unique_id}" if name.blank?
  end
end
