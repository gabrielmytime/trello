# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :boards do
        resources :columns do
          resources :stories
        end
      end
    end
  end
end
