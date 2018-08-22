Rails.application.routes.draw do
  get 'news/index'
  root 'news#index'
end
