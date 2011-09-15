# To change this template, choose Tools | Templates
# and open the template in the editor.

#config.rails3amf.gateway_path = "/rubyamf/gateway"
config.rails3amf.class_mapping do |m|
  m.map :as => 'Test::User', :ruby => 'Character'
  m.map :as => 'vo.Course', :ruby => 'Course'
end
#config.rails3amf.map_params :controller => 'UserController', :action => 'getUser', :params => [:session_id]
