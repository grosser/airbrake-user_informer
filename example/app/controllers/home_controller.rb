class HomeController < ActionController::Base
  protect_from_forgery with: :exception

  def good
    render plain: "Hello"
  end

  def error
    raise "Hello"
  end
end
