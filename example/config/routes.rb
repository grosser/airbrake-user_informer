Rails.application.routes.draw do
  get "/", to: "home#good"
  get "/error", to: "home#error"
end
