Rails.application.routes.draw do
  # Khi chuyển route thì nội dung của trang web sẽ hiển thị theo default loacale. Để hiển thị theo nhiều ngôn ngữ ta cấu hình router trong scope như sau:
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/help"

    resources :users
  end
end
