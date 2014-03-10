ProjectArlo::Application.routes.draw do

  scope '/api/service/v1', defaults: {format: :json} do
    devise_for :users
    devise_scope :user do
      match '/login', to: 'sessions#create', via: :post
    end
  end

  namespace :api, defaults: {format: :json} do
    namespace :service do
      namespace :v1 do
        resources :accounts, only: [:index, :show, :update, :create, :destroy]
        resources :groups, only: [:index, :show, :update, :create, :destroy]

        resources :issues, only: [:index, :show, :update, :create, :destroy] do
          resources :solutions, only: [:index, :create]
          resources :comments, only: [:index, :create]
        end

        resources :solutions, only: [:show, :update, :destroy] do
          resources :comments, only: [:index, :create]
        end

        resources :categories, only: [:index, :show, :update, :create, :destroy]

        resources :comments, only: [:show, :update, :destroy]

        match '/groups/:id/addMember', to: 'groups#add_members', via: :put, as: 'add_members'
        match '/groups/:id/removeMember', to: 'groups#remove_members', via: :put, as: 'remove_members'

        match '/accounts/:id/addGroup', to: 'accounts#add_groups', via: :put, as: 'add_groups'
        match '/accounts/:id/removeGroup', to: 'accounts#remove_groups', via: :put, as: 'remove_groups'

        match '/issues/:id/addCategory', to: 'issues#add_category', via: :put, as: 'add_category'
        match '/issues/:id/removeCategory', to: 'issues#remove_category', via: :put, as: 'remove_category'
      end
    end
  end
end
