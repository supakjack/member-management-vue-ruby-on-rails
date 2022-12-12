Rails.application.routes.draw do
  post   'sessions/sign_up',  to: 'sessions#sign_up'
  post   'sessions/sign_in',  to: 'sessions#sign_in'
  delete 'sessions/sign_out', to: 'sessions#sign_out'
  post   'sessions/confirm',  to: 'sessions#confirm'
  get    'users/me',          to: 'users#me'
  get    'users/show/:id',    to: 'users#show'


  # redirect generate url from devise
  get    'user',             to: redirect('/')
  post   'user',             to: redirect('/')
  get    'user/:uri',        to: redirect('/')
  post   'user/:uri',        to: redirect('/')
  devise_for :user
end
