Rails.application.routes.draw do
  get 'pages/index'
  post 'pages/parse_file'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
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
