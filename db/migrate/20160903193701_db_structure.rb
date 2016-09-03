class DbStructure < ActiveRecord::Migration
  def change
    create_table :battles, {primary_key: :battle_number} do |t|
      t.string    :name
      t.integer   :year
      t.string    :attacker_king
      t.string    :defender_king
      t.string    :attacker_1
      t.string    :attacker_2
      t.string    :attacker_3
      t.string    :attacker_4
      t.string    :defender_1
      t.string    :defender_2
      t.string    :defender_3
      t.string    :defender_4
      t.string    :attacker_outcome
      t.string    :battle_type
      t.integer   :major_death
      t.integer   :major_capture
      t.integer   :attacker_size
      t.integer   :defender_size
      t.string    :attacker_commander
      t.string    :defender_commander
      t.boolean   :summer
      t.string    :location
      t.string    :region
      t.text      :note
    end
    # execute "ALTER TABLE battles ADD PRIMARY KEY (battle_number);"
  end
end
