
class LoggedInConstraint < Struct.new(:value)
  def matches?(request)
    request.cookies.key?("user_credentials") == value
  end
end

