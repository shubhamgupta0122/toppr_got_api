require 'csv'
namespace :import do
  desc 'Import data from csv'
  task battles: :environment do
    csv_text = File.read("#{ Rails.root }/db/battles.csv")
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      Battle.create(row.to_hash)
    end
  end
end