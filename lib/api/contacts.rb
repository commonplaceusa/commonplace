class API
  class Contacts < Authorized
    helpers do

    end

    get "/yahoo" do
      serialize Contacts::Yahoo(request_body["username"], request_body["password"])
    end
  end
end
