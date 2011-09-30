require 'resque_scheduler'
Dir[File.join(Rails.root, 'app', 'workers', '*.rb')].each { |file| require file }

config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
Resque.redis = Redis.new(:host => config['host'], :port => config['port'], :password => config['password'])

