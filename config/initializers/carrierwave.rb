CarrierWave.configure do |config|
    config.fog_credentials = {
        :provider               => ENV['PROVIDER'],
        :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
        :region                 => ENV['REGION'], # Change this for different AWS region. Default is 'us-east-1'
    }
    config.fog_directory  = ENV['FOG_DIRECTORY']
  end