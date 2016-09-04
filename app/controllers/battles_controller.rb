class BattlesController < ActionController::Base
  before_action :load_battle, only: [:show, :update, :destroy, :edit]
  before_action :load_atrs,   only: [:show, :edit]
  layout 'application'

  def index
    @battles = Battle.all.order(:battle_number)

    respond_to do |format|

      format.html

      format.json {
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

        render json: {
          battles: battles,
          next: next_url
        }, status: 200
      }

    end
  end

  def new
    @battle = Battle.new
  end

  def create
    battle = Battle.new(battle_params)
    respont_to do |format|
      format.html {
        if battle.save
          redirect_to battles_path
        else
          render action: 'new'
        end
      }
      format.json {
        if battle.save
          render json: @battle, status: 200
        else
          render json: @battle.errors, status: 422
        end
      }
    end
  end

  def show
    respond_to do |format|
      format.html

      format.json {
        render json: @battle, status: 200
      }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      format.html {
        if @battle.update(battle_params)
          redirect_to battles_path
        else
          render action: 'edit'
        end
      }

      format.json {
        if @battle.update(battle_params)
          render json: @battle, status: 200
        else
          render json: @battle.errors, status: 422
        end
      }
    end
  end

  def destroy
    respond_to do |format|
      format.html {
        @battle.destroy
        redirect_to battles_path
      }

      format.json {
        if @battle.destroy
          render json: {success: true}, status: 200
        else
          render json: @battle.errors, status: 422
        end
      }
    end
  end

  def stats
    battle_types = Battle.select("distinct(battle_type)").
      map(&:battle_type) - [nil]
    hash = {
      most_active: {
        attacker_king: Battle.highest_freq(:attacker_king),
        defender_king: Battle.highest_freq(:defender_king),
        region: Battle.highest_freq(:region),
        name: Battle.highest_freq(:name)
      },
      attacker_outcome: {
        win: Battle.where(attacker_outcome: 'win').count,
        loss: Battle.where(attacker_outcome: 'loss').count
      },
      battle_type: battle_types,
      defender_size: {
        average: Battle.average(:defender_size).to_i,
        min: Battle.maximum(:defender_size),
        max: Battle.minimum(:defender_size)
      }
    }
    render json: hash, status: 200
  end

  def list
    places = Battle.where.not(location: nil).distinct.pluck(:location)
    render json: {places: places}, status: 200
  end

  def count
    render json: { count: Battle.count }, status: 200
  end

  def search
    results = Battle.all
    searchable = [:name, :attacker_king, :defender_king, :location, :battle_type]
    searchable.each do |s|
      if params.has_key?(s)
        results = results.search(s, params[s])
      end
    end
    render json: {
      count: results.count,
      battles: results.order(:battle_number)
    }, status: 200
  end

  private

  def battle_params
    params.require(:battle).permit(:name, :year, :attacker_king, :defender_king,
      :attacker_1, :attacker_2, :attacker_3, :attacker_4, :defender_1,
      :defender_2, :defender_3, :defender_4, :attacker_outcome,
      :battle_type, :major_death, :major_capture, :attacker_size,
      :defender_size, :attacker_commander, :defender_commander,
      :summer, :location, :region, :note)
  end

  def load_battle
    @battle = Battle.find(params[:id])
  end

  def load_atrs
    @atrs = [:name, :attacker_king, :defender_king, :attacker_1,
      :attacker_2, :attacker_3, :attacker_4, :defender_1, :defender_2,
      :defender_3, :defender_4, :battle_type, :year, :major_death,
      :major_capture, :attacker_size, :defender_size,
      :attacker_commander, :defender_commander, :location, :region]
  end
end