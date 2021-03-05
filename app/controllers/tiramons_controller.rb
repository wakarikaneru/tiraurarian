class TiramonsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :adventure, :get, :training, :set_style, :set_wary, :set_move, :get_move, :inspire_move, :refresh, :rename, :set_rank, :release, :edit_move]
  before_action :complete_battles, only: [:show, :adventure, :training, :set_style, :set_wary, :set_move, :get_move, :inspire_move, :refresh, :rename, :set_rank, :release, :edit_move]
  before_action :set_tiramon, only: [:show, :adventure, :get, :training, :set_style, :set_wary, :set_move, :get_move, :inspire_move, :refresh, :rename, :set_rank, :release, :edit_move]

  def index
    @tiramons = []

    (1..5).each do |rank|
      @tiramons[rank] = Tiramon.where(rank: rank).where.not(tiramon_trainer: nil).order(id: :desc)
    end
  end

  def adventure
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    @data = @tiramon.getData
    @disp_data = Tiramon.getBattleData(@data)
    @adventure_data = @tiramon.getAdventureData

    @my_tiramon = @tiramon.tiramon_trainer_id == @tiramon_trainer.id
    if @my_tiramon
      @about = 1
    else
      @about = [((100.0 - @tiramon_trainer.level) / 10.0).to_i, 10, 1].sort.second
    end

    @enemy_class = params[:enemy_class].to_i
    @stage = params[:stage].to_i

    @enemy_tiramons = TiramonEnemy.where(enemy_class: @enemy_class, stage: @stage).order(enemy_id: :asc)
  end

  def scout
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    if @tiramon_trainer.move?
      @tiramon = Tiramon.generate(@tiramon_trainer, 0, 20)
      @data = @tiramon.getData
      @disp_data = Tiramon.getBattleData(@data)
      @about = [(100 - @tiramon_trainer.level) / 10, 10, 1].sort.second

      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "チラモンを発見しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "行動ポイントが足りません。" )}
        format.json { head :no_content }
      end
    end
  end

  def get
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    if @tiramon.get?(@tiramon_trainer)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "ゲットしました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "ゲットできませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def training
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    training = params[:training].to_i

    if @tiramon.training?(@tiramon_trainer, training)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "育成しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "育成できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def set_style
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    intuition = [params[:intuition].to_i, 100, 0].sort.second
    study = [params[:study].to_i, 100, 0].sort.second
    flexible = [params[:flexible].to_i, 100, 0].sort.second
    wary = [params[:wary].to_i, 100, 0].sort.second
    wary_list = []
    wary_list[0] = [params[:wary_0].to_i, 100, 0].sort.second
    wary_list[1] = [params[:wary_1].to_i, 100, 0].sort.second
    wary_list[2] = [params[:wary_2].to_i, 100, 0].sort.second

    style = {intuition: intuition, study: study, flexible: flexible, wary: wary, wary_list: wary_list}

    if @tiramon.set_style?(@tiramon_trainer, style)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "スタイルを設定しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "スタイルを設定できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def set_wary
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    wary_list = []
    wary_list[0] = [params[:wary_0].to_i, 100, 0].sort.second
    wary_list[1] = [params[:wary_1].to_i, 100, 0].sort.second
    wary_list[2] = [params[:wary_2].to_i, 100, 0].sort.second

    if @tiramon.set_wary?(@tiramon_trainer, wary_list)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "警戒しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "警戒できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def set_move
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    moves = [[], [], [], []]

    if params[:mode] == "easy"
      moves[0] << params[:move]["0"]["0"]
      moves[0] << params[:move]["0"]["1"]
      moves[0] << params[:move]["0"]["2"]
      moves[0] << params[:move]["0"]["3"]
      moves[1] = moves[0]
      moves[2] = moves[0]
      moves[3] = moves[0]
    else
      moves[0] << params[:move]["0"]["0"]
      moves[0] << params[:move]["0"]["1"]
      moves[0] << params[:move]["0"]["2"]
      moves[0] << params[:move]["0"]["3"]

      moves[1] << params[:move]["1"]["0"]
      moves[1] << params[:move]["1"]["1"]
      moves[1] << params[:move]["1"]["2"]
      moves[1] << params[:move]["1"]["3"]

      moves[2] << params[:move]["2"]["0"]
      moves[2] << params[:move]["2"]["1"]
      moves[2] << params[:move]["2"]["2"]
      moves[2] << params[:move]["2"]["3"]

      moves[3] << params[:move]["3"]["0"]
      moves[3] << params[:move]["3"]["1"]
      moves[3] << params[:move]["3"]["2"]
      moves[3] << params[:move]["3"]["3"]
    end

    if @tiramon.set_move?(@tiramon_trainer, moves)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "戦い方を設定しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "戦い方を設定できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def get_move
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    move = params[:get_move]

    if @tiramon.get_move?(@tiramon_trainer, move)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "新しい技を習得しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "新しい技を習得できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def inspire_move
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    if @tiramon.inspire_move?(@tiramon_trainer)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "新しい技をひらめきました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "新しい技をひらめきませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def refresh
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    if @tiramon.refresh?(@tiramon_trainer)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "リフレッシュしました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "リフレッシュできませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def rename
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    name = params[:name]

    if @tiramon.rename?(@tiramon_trainer, name)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "改名しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "改名できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def set_rank
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    rank = [params[:rank].to_i, 1, 6].sort.second

    if @tiramon.set_rank?(@tiramon_trainer, rank)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, notice: "階級を変更しました！" )}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "階級を変更できませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def release
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    if @tiramon.release?(@tiramon_trainer)
      respond_to do |format|
        format.html { redirect_to tiramon_trainer_path(@tiramon_trainer), notice: "チラモンをにがしました！バイバイ！" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "チラモンをにがせませんでした。" )}
        format.json { head :no_content }
      end
    end
  end

  def show
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)
    @data = @tiramon.getData
    @disp_data = Tiramon.getBattleData(@data)
    @adventure_data = @tiramon.getAdventureData

    @my_tiramon = @tiramon.tiramon_trainer_id == @tiramon_trainer.id
    if @my_tiramon
      @about = 1
    else
      @about = [((100.0 - @tiramon_trainer.level) / 10.0).to_i, 10, 1].sort.second
    end

    @right = ((@tiramon.right == @tiramon_trainer.id) and (Time.current < @tiramon.get_limit ))
    @have_ball = (1 <= @tiramon_trainer.tiramon_ball)
    @getable = (!@my_tiramon and @right and @have_ball)

    @can_act = @tiramon.can_act?
    @adjust = @tiramon.adjust?

    @training = @tiramon.getTrainingText

    move_list = TiramonMove.first.getData
    get_moves = @tiramon.getGetMove.sort

    @select = []
    get_moves.each do |move|
      move_data = TiramonMove.getMoveData(move_list.find{|m| m[:id] == move})
      @select << ["[" + Constants::TIRAMON_ELEMENTS[move_data[:element]]+ "][" + move_data[:move_value_attack].to_i.to_s + "] " + move_data[:name], move]
    end

    @ranks = []
    (1..6).each do |rank|
      roster = Tiramon.where(rank: rank).where.not(tiramon_trainer: nil).count
      @ranks << ["[" + roster.to_i.to_s + "] " + Constants::TIRAMON_RULE_NAME[rank], rank]
    end
  end

  def edit_move
    @tiramon_trainer = TiramonTrainer.find_or_create_by(user_id: current_user.id)

    @data = @tiramon.getData
    @disp_data = Tiramon.getBattleData(@data)

    @my_tiramon = @tiramon.tiramon_trainer_id == @tiramon_trainer.id
    if @my_tiramon
      @about = 1
    else
      @about = [(100 - @tiramon_trainer.level) / 10, 10, 1].sort.second
    end

    @moves = @data[:moves]

    move_list = TiramonMove.first.getData
    available_moves = @tiramon.getMove.sort

    @select = []
    available_moves.each do |move|
      move_data = TiramonMove.getMoveData(move_list.find{|m| m[:id] == move})
      @select << ["[" + Constants::TIRAMON_ELEMENTS[move_data[:element]]+ "][" + move_data[:move_value_attack].to_i.to_s + "] " + move_data[:name], move]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def complete_battles
      Tiramon.complete_battles
    end

    def set_tiramon
      @tiramon = Tiramon.find(params[:id])
    end
end
