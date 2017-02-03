require "httparty"

class Kele
  include HTTParty

  def initialize(username, password)
    @bloc_base_api_url = "https://www.bloc.io/api/v1"
    @user_auth_token = self.class.post("https://www.bloc.io/api/v1/sessions",
                       body: {email: username, password: password})
    raise "Wrong Email and/or Password" if @user_auth_token.code != 200
  end

end
