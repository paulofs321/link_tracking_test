Rails.application.routes.draw do
  resources :posts

  get "admin", action: :index, controller: "admin"
  post "link_clicks", action: :create, controller: "link_clicks"
  # get "/429", to: "errors#rate_limit_exceeded", :via => :all

  get "errors/rate_limit_exceeded", to: "rate_limit_exceeded", controller: "errors"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
