Strano::Application.routes.draw do

  devise_for :users

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'

  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new'
    delete 'sign_out', :to => 'devise/sessions#destroy'
  end

  resources :projects, :except => [:edit, :update] do
    get :pull, :on => :member
    resources :jobs, :except => [:new,:index] do
      get 'new/:task', :action => :new, :on => :collection, :as => :new
    end
    resources :tasks, :only => [:new, :create, :index]
  end

  root :to => "dashboard#index"

end
