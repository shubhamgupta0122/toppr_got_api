class Battle < ActiveRecord::Base
  # set_primary_key :battle_number

  def self.highest_freq(column)
    column = column.to_s
    Battle.select("#{column}, count(#{column})").group(column).order(count: :desc).limit(1)[0].send(column)
  end

end
