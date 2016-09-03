class BattlesController < ActionController::Base
  before_action :load_battle, only: [:show, :update, :destroy, :edit]
  before_action :load_atrs,   only: [:show, :edit]

  def index
    @battles = Battle.all.order(:battle_number)
  end

  def new
    @battle = Battle.new
  end

  def create
    @battle = Battle.new(battle_params)
    if @battle.save
      redirect_to battles_path
    else
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @battle.update(battle_params)
      redirect_to battles_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @battle.destroy
    redirect_to battles_path
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