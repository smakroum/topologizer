Rails.application.routes.draw do
  get 'calendar/index'

  resources :events
  devise_for :users
  get 'pages/index'
  post 'pages/parse_file'
  get 'pages/graph/data/:id', to: 'pages#graph_data'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  defaults format: :json do
    constraints( id: /\d+/) do
      get 'topologies/current', to: 'topologies#current'
      resources :topologies, except: [:new, :edit] do
        get 'nodes/count', to: 'nodes#count'
        resources :nodes, except: [:new, :edit]
        get 'nodes/:id/links', to: 'nodes#show_links'
      end
    end
  end
end
