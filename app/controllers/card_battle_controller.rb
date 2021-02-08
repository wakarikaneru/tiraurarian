class CardBattleController < ApplicationController
  before_action :authenticate_user!, only: [:standby, :battle, :purchase, :expand_box]
  before_action :set_rule, only: [:standby, :battle]
  before_action :set_card_deck_id, only: [:battle]
  after_action :reset_card_get_result, only: [:index]

  def index
    if user_signed_in?
      @user = current_user
      @box = CardBox.find_or_create_by(user_id: current_user.id)
      @cards = Card.where(card_box_id: @box.id).order(:element).order(power: :desc)
      @count = Card.where(card_box_id: @box.id).count
      @max_buy = [((@box.size - @count) / Constants::CARD_PACK).floor , 0].max
    end

    card_king_0 = CardKing.where(rule: 0).order(id: :desc).first
    card_king_1 = CardKing.where(rule: 1).order(id: :desc).first
    card_king_2 = CardKing.where(rule: 2).order(id: :desc).first

    if card_king_0.blank?
      CardKing.establish(0)
    end

    if card_king_1.blank?
      CardKing.establish(1)
    end

    if card_king_2.blank?
      CardKing.establish(2)
    end

    @card_kings = [card_king_0, card_king_1, card_king_2]

    @card_get_result = CardGetResult.where(user_id: current_user.id)

  end

  def standby
    if user_signed_in?
      @user = current_user
      @box = CardBox.find_or_create_by(user_id: current_user.id)
      @card_decks = CardDeck.where(card_box_id: @box.id)
    end

    @card_king = CardKing.where(rule: @rule).order(id: :desc).first
  end

  def battle
    @failure = false
    @card_king = CardKing.where(rule: @rule).order(id: :desc).first
    @card_king_deck = @card_king.card_deck
    if current_user == @card_king.user
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "自分とは闘えません。" )}
        format.json { head :no_content }
      end
      return
    end

    if current_user == @card_king.last_challenger and false
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "連続挑戦はできません。" )}
        format.json { head :no_content }
      end
      return
    end

    @card_deck = CardDeck.find_by(id: @card_deck_id)

    if @card_deck.blank?
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "デッキがありません。" )}
        format.json { head :no_content }
      end
      return
    end

    unless @card_deck.isValid?(current_user, @rule.to_i)
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "デッキが異常です。" )}
        format.json { head :no_content }
      end
      return
    end

    if @card_deck.isKing?
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "現在王座についているデッキでは挑戦できません。" )}
        format.json { head :no_content }
      end
      return
    end

    @cards = @card_deck.getCard(false)

    # 王座認定
    if @card_king.user.blank?
      @failure = true

      new_king = CardKing.new
      new_king.rule = @rule
      new_king.user_id = current_user.id
      new_king.card_deck_id = @card_deck_id
      new_king.defense = 0
      new_king.save!
      @card_king = new_king

      return
    end
    @card_king_name = @card_king.user.name

    @king_cards = @card_king_deck.getCard(true)

    @environment = Card.getEnvironmentText

    @results = []
    @cards.length.times { |i|
    	@results.push(Card.battle(@cards[i], @king_cards[i]))
    }

    wins = 0
    @results.length.times { |i|
    	wins += @results[i][:result]
    }

    @winner = 0

    if 0 < wins
      @winner = 1
    elsif wins < 0
      @winner = -1
    else
      @winner = 0
    end

    # 商品贈呈
    if @winner == 1
      Notice.generate(@card_king.user_id, 0, "カードバトル運営", Constants::CARD_RULE_NAME[@card_king.rule] + "王座から陥落しました。" + "防衛回数は" + @card_king.defense.to_s + "回でした。")

      new_king = CardKing.new
      new_king.rule = @rule
      new_king.user_id = current_user.id
      new_king.card_deck_id = @card_deck_id
      new_king.defense = 0
      new_king.save!
      @card_king = new_king
      current_user.add_points(Constants::CARD_PRIZE)
    else
      @card_king.last_challenger = current_user
      @card_king.defense = @card_king.defense + 1
      @card_king.save!
      @card_king.user.add_points(Constants::CARD_PRIZE)
    end

    @defense = @card_king.defense
    @generation = @card_king.getGeneration

    # カード破壊
    @destroy = 0
    @card_destroy = 0
    if @winner == -1
      if rand() < Constants::CARD_DESTROY_RATIO
        @destroy = 1

        @card_destroy = rand(0..2)
        @card_deck.destroy
        @cards[@card_destroy].destroy
      end
    end
  end

  def purchase
    num_str = params[:point]
    num = num_str.to_i
    if user_signed_in?
      if Card.purchase?(current_user, num)
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "#{num}パック(#{num * Constants::CARD_PACK}枚)購入しました。")}
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, alert: "購入できませんでした。" )}
          format.json { head :no_content }
        end
      end
    end
  end

  def expand_box
    num_str = params[:point]
    num = num_str.to_i
    if user_signed_in?
      if CardBox.expand?(current_user, num)
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, notice: "#{num}枚分拡張しました。" )}
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_back(fallback_location: root_path, alert: "拡張できませんでした。" )}
          format.json { head :no_content }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rule
      @rule = params[:rule].to_i

      if @rule == 0 or @rule == 1 or @rule == 2
      else
        @rule = 0
      end
    end

    def set_card_deck_id
      @card_deck_id = params[:deck]
    end

    def reset_card_get_result
      CardGetResult.where(user_id: current_user.id).destroy_all
    end
end
