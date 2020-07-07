ELASTICSEARCH_CONFIG = proc do
  host= ENV['ELASTIC_HOST']
  port= ENV['ELASTIC_PORT']

  elastic_ready = host.present? and port.present?

  elasticsearch_url= if elastic_ready
    "http://#{host}:#{port}"
  else
    "http://localhost:9200"
  end
end

if File.exists?("config/elasticsearch.yml")
    config.merge!(YAML.load_file("config/elasticsearch.yml")[Rails.env].symbolize_keys)
end

Elasticsearch::Model.client = Elasticsearch::Client.new(url: ELASTICSEARCH_CONFIG.call, retry_on_failure: 5)


  if Rails.env.development?
    tracer = ActiveSupport::Logger.new('log/elasticsearch.log')
    tracer.level =  Logger::DEBUG
  end