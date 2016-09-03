class Api::BattlesController < ActionController::Base
  before_action :load_battle, only: [:show, :update, :destroy]

  def index
    limit = (params[:limit] || 10).to_i
    offset = (params[:offset] || 0).to_i

    total_count = Battle.count
    battles = Battle.order(:battle_number).
      offset(offset).limit(limit)

    has_more = total_count - battles.size
    if has_more > 0
      new_offset = offset + limit
      next_url = "#{request.base_url+request.path}?offset=#{new_offset}&limit=#{limit}"
    else
      next_url = nil
    end

    # if offset > 0

    render json: {
      battles: battles,
      next: next_url
    }, status: 200
  end

  def create
    battle = Battle.new(battle_params)
    if battle.save
      render json: @battle, status: 200
    else
      render json: @battle.errors, status: 422
    end
  end

  def show
    render json: @battle, status: 200
  end

  def update
    if @battle.update(battle_params)
      render json: @battle, status: 200
    else
      render json: @battle.errors, status: 422
    end
  end

  def destroy
    if @battle.destroy
      render json: {success: true}, status: 200
    else
      render json: @battle.errors, status: 422
    end
  end

  private

  def battle_params
    params.permit(:name, :year, :attacker_king, :defender_king,
      :attacker_1, :attacker_2, :attacker_3, :attacker_4, :defender_1,
      :defender_2, :defender_3, :defender_4, :attacker_outcome,
      :battle_type, :major_death, :major_capture, :attacker_size,
      :defender_size, :attacker_commander, :defender_commander,
      :summer, :location, :region, :note)
  end

  def load_battle
    @battle = Battle.find(params[:id])
  end
end