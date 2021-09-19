class Ban < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: :create_user_id, primary_key: :id
end
