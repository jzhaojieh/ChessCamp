Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  get 'users/index'

  get 'users/show'

  get 'users/edit'

  get 'users/new'

  get 'users/create'

  get 'users/update'

  get 'users/destroy'

  get 'students/index'

  get 'students/show'

  get 'students/edit'

  get 'students/new'

  get 'students/create'

  get 'students/update'

  get 'students/destroy'

  # get 'registrations/index'

  # get 'registrations/show'

  # get 'registrations/edit'

  # get 'registrations/new'

  # get 'registrations/create'

  # get 'registrations/update'

  # get 'registrations/destroy'

  get 'families/index'

  get 'families/show'

  get 'families/edit'

  get 'families/new'

  get 'families/create'

  get 'families/update'

  get 'families/destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  root 'home#index'

  # Routes for main resources
  resources :camps
  resources :instructors
  resources :locations
  resources :curriculums
  resources :sessions
  # resources :registrations
  resources :students
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Routes for managing camp instructors
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor

  # Routes for managing registrations
  get 'camps/:id/students', to: 'camps#students', as: :registrations
  post 'camps/:id/students', to: 'registrations#create', as: :create_registration
  delete 'camps/:id/students/:student_id', to: 'registrations#destroy', as: :remove_registration
end








