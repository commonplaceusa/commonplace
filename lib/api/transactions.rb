class API
  class Transactions < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with Posts.

    helpers do

      # Returns the Postlike klass
      def klass
        Transaction
      end    

      # Set the transaction's attributes using the given request_body
      # 
      # Request params:
      #  title -
      #  body - 
      #  price -
      # 
      # Returns true on success, false otherwise
      def update_attributes
        find_postlike.update_attributes(
          title:  request_body["title"],
          description:  request_body["body"],
          price:  request_body["category"]
        )
      end

    end
   end
end
