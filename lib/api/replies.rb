class API
  class Replies < Base
  
    helpers do
    
      def auth(reply)
        halt [401, "wrong community"] unless in_comm(reply.repliable.community.id)
        reply.user == current_account or current_account.admin
      end

    end
  
    delete "/:id" do |reply_id|
      reply = Reply.find(reply_id)
      unless reply.present?
        [404, "errors"]
      end
      
      if auth(reply)
        reply.destroy
      else
        [401, "unauthorized"]
      end
    end
    
    post "/:id/thank" do |id|
      thank(Reply, id)
    end
    
  end
end
