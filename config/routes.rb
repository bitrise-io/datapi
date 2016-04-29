Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/data/:typeid', to: 'data_items#list_by_typeid'
  post '/data/:typeid', to: 'data_items#create_by_typeid'
end
