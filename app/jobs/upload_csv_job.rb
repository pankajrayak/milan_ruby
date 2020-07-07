require 'csv'    
class UploadCsvJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later

  filename='public/file/report.csv'

CSV.foreach(filename, :headers => true) do |row|
  EarlyBirdRegistration.create!(row.to_hash)
end
  end
end
