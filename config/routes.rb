Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :schools do
    collection do
      get :export_sertification_member_contest
    end
  end
  resources :member_contests
  resources :sertifications do
    collection do
      get :export_sertification
      get :export_jumum
    end
  end
  root 'schools#index'
end
