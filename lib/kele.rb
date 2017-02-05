require "httparty"
require "json"

class Kele
  include HTTParty

  def initialize(username, password)
    @bloc_base_api_url = "https://www.bloc.io/api/v1"
    response = self.class.post("https://www.bloc.io/api/v1/sessions",
                       body: {email: username, password: password})
    @auth_token = response["auth_token"]
    raise "Wrong Email and/or Password" if response.code != 200
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @my_data = JSON.parse(response.body)
  end

end
