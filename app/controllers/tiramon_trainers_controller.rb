class TiramonTrainersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    @tiramons = Tiramon.where(tiramon_trainer_id: @tiramon_trainer.id)
    @negotiations_tiramons = Tiramon.where(right: @tiramon_trainer.id).where("get_limit > ?", Time.current)
  end

end
