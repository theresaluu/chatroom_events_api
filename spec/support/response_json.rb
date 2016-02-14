module ResponseJSON
  def response_json
    if response.message == "OK"
      JSON.parse(response.body).merge("status" => "ok")
    else
      JSON.parse(response.body)
    end
  end
end

RSpec.configure do |config|
  config.include ResponseJSON
end
