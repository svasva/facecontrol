RubyAMF.configure do |config|
  config.gateway_path = "/amf"
  config.auto_class_mapping = true
end

RubyAMF::ClassMapper.define do |m|
     m.map :as => 'Object', :ruby => 'Hash'
end
