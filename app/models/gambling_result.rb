class GamblingResult < ApplicationRecord
  belongs_to :user

  def self.generate(user_id = 0, result = false, point = 0, game = nil)
    gr = GamblingResult.new

    gr.user_id = user_id
    gr.result = result
    gr.point = point
    gr.game = game
    gr.create_datetime = Time.current
    gr.save!
  end
end
