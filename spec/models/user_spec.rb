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
require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
