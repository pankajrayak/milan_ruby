require 'elasticsearch/rails/tasks/import'

# bundle exec rake environment elasticsearch:import:model CLASS='User' BATCH=100
 STDOUT.sync = true
 STDERR.sync = true
 
 begin; require 'ansi/progressbar'; rescue LoadError; end
 
 namespace :elasticsearch do
 
   task :import => 'import:model'
 
   namespace :import do
     import_model_desc = <<-DESC.gsub(/    /, '')
     
     rake environment elasticsearch:import:model CLASS='User' BATCH=100 FORCE=y
     
     DESC
     desc import_model_desc
     task :model do
       if ENV['CLASS'].to_s == ''
         puts '='*90, 'USAGE', '='*90, import_model_desc, ""
         exit(1)
       end
 
       klass  = eval(ENV['CLASS'].to_s)
       total  = klass.count rescue nil
       pbar   = ANSI::Progressbar.new(klass.to_s, total) rescue nil
       pbar.__send__ :show if pbar
 
       unless ENV['DEBUG']
         begin
           klass.__elasticsearch__.client.transport.logger.level = Logger::WARN
         rescue NoMethodError; end
         begin
           klass.__elasticsearch__.client.transport.tracer.level = Logger::WARN
         rescue NoMethodError; end
       end
 
       total_errors = klass.__elasticsearch__.import force:      ENV.fetch('FORCE', false),
                                   batch_size: ENV.fetch('BATCH', 1000).to_i,
                                   index:      ENV.fetch('INDEX', nil),
                                   type:       ENV.fetch('TYPE',  nil),
                                   scope:      ENV.fetch('SCOPE', nil) do |response|
         pbar.inc response['items'].size if pbar
         STDERR.flush
         STDOUT.flush
       end
       pbar.finish if pbar
 
       puts "[IMPORT] #{total_errors} errors occurred" unless total_errors.zero?
       puts '[IMPORT] Done'
     end
 
     desc <<-DESC.gsub(/    /, '')
       Import all indices from `app/models` (or use DIR environment variable).
         $ rake environment elasticsearch:import:all DIR=app/models
     DESC
     task :all do
       dir    = ENV['DIR'].to_s != '' ? ENV['DIR'] : Rails.root.join("app/models")
 
       puts "[IMPORT] Loading models from: #{dir}"
       Dir.glob(File.join("#{dir}/**/*.rb")).each do |path|
         model_filename = path[/#{Regexp.escape(dir.to_s)}\/([^\.]+).rb/, 1]
 
         next if model_filename.match(/^concerns\//i) # Skip concerns/ folder
 
         begin
           klass = model_filename.camelize.constantize
         rescue NameError
           require(path) ? retry : raise(RuntimeError, "Cannot load class '#{klass}'")
         end
 
         # Skip if the class doesn't have Elasticsearch integration
         next unless klass.respond_to?(:__elasticsearch__)
 
         puts "[IMPORT] Processing model: #{klass}..."
 
         ENV['CLASS'] = klass.to_s
         Rake::Task["elasticsearch:import:model"].invoke
         Rake::Task["elasticsearch:import:model"].reenable
         puts
       end
     end
 
   end
 
 end