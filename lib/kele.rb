require "httparty"
require "json"
require "roadmap"

class Kele
  include HTTParty
  include Roadmap

  def initialize(username, password)
    @bloc_base_api_url = "https://www.bloc.io/api/v1"
    response = self.class.post("https://www.bloc.io/api/v1/sessions",
                       body: {email: username, password: password})
    @auth_token = response["auth_token"]
    @my_mentor_id = response["mentor_id"]
    raise "Wrong Email and/or Password" if response.code != 200
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @my_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @my_mentor_availability = JSON.parse(response.body)
  end

  def get_messages(num = 0)
    if num == 0
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token }, body: {"page": "#{num}"})
    end

    @messages = JSON.parse(response.body)
  end

  def create_messages(sender, recipient_id, subject, stripped_text)
      response = self.class.post("https://www.bloc.io/api/v1/messages", headers: { "authorization" => @auth_token },
          body: {"sender": sender,
                 "recipient_id": recipient_id,
                 "subject": subject,
                 "stripped-text": stripped_text,
                 })
      response
  end

end
