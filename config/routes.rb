Rails.application.routes.draw do
  # get "pasword_resets/new"
  # get "pasword_resets/edit"
  resources :account_activations, only: :edit
  resources :password_resets
  # Khi chuyển route thì nội dung của trang web sẽ hiển thị theo default loacale. Để hiển thị theo nhiều ngôn ngữ ta cấu hình router trong scope như sau:
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :account_activation, only: %i(edit)
    resources :password_resets
  end
end
