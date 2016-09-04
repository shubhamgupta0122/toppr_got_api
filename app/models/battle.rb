class Battle < ActiveRecord::Base

  # Search the models table
  # searches the [column] for any occurences of [q]
  # @param column [Symbol]
  # @param q [String]
  # @return [Battle::ActiveRecord_Relation] search result
  scope :search, -> (column, q) do
    q="%#{q}%"
    where("#{column.to_s} ILIKE ?", q)
  end

  # Find the highest occuring value for any column
  # @param column [Symbol or String]
  # @return [String] highest occuring value
  def self.highest_freq(column)
    column = column.to_s
    Battle.select("#{column}, count(#{column})").group(column).order(count: :desc).limit(1)[0].send(column)
  end

end
