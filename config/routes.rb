Rails.application.routes.draw do
  # Khi chuyển route thì nội dung của trang web sẽ hiển thị theo default loacale. Để hiển thị theo nhiều ngôn ngữ ta cấu hình router trong scope như sau:
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "static_pages/help"
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
end
