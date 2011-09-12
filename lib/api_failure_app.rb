class ApiFailureApp
  def self.call(env)
    [400, {"Content-Type" => "application/json"}, "{ status: 400 }"]
  end
end
