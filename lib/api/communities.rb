class API
  class Communities < Base

    helpers do

      # Finds the community by params[:id] or returns 404
      def find_community
        @community ||= case params[:id]
                       when /^\d+/
                         Community.find_by_id(params[:id])
                       else
                         Community.find_by_slug(params[:id])
                       end
        @community || (halt 404)
      end

      # Performs a Sunspot search for the given PostLike(s), params, and community
      #
      # Returns a JSON string of the results
      def search(klass, params, community_id)
        keywords = phrase(params["query"])
        search = Sunspot.search(klass) do
          keywords keywords
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Performs a search like #search, but ordered most recent first
      #
      # Returns a JSON string of the results
      def chronological_search(klass, params, community_id)
        keywords = phrase(params["query"])
        search = Sunspot.search(klass) do
          keywords keywords
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Why is this not scoped by community? (appears to be intentional)
      def auth_search(klass, params)
        keywords = phrase(params["query"])
        search = Sunspot.search(klass) do
          keywords keywords
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Returns a chronological list of the given classes for the given community
      def chronological(klass, params, community_id)
        search = Sunspot.search(klass) do
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1, :per_page => params["limit"])
          with(:community_id, community_id)
        end
        serialize(search)
      end

      # Performs a Sunspot search with no keywords
      #
      # Returns a JSON string of the results
      def list_all(klass, params, community_id)
        search = Sunspot.search(klass) do
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Returns the JSON results of an Event search in the given community
      def event_search(params, community_id)
        keywords = phrase(params["query"])
        search = Sunspot.search(Event) do
          keywords keywords
          order_by(:date, :desc)
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Turns a string into a array to be used as a search phrase
      #
      # Example:
      #   phrase(%{foo "baz baz" qux})
      #   # => ["foo", "\"bax baz\"", "qux"]
      #
      # Note: is returning those escaped quotes proper behavior?
      def phrase(string)
        string.split('"').each_with_index.map { |object, i|
          i.odd? ? %{"#{object}"} : object.split(" ")
        }.flatten
      end

      def filter_users_by_tag(tag,haveornot,community_id)
        @resident=false
        @tag=JSON.parse tag
        case @tag['type']
          when "action"
            case @tag['tag']
              when "post"
                @ids=Post.all.map {|a| a.user_id}.uniq
              when "email"
                @emails=SentEmail.where(:status=>"opened").map {|a| a.recipient_email}.uniq
                @ids=User.where(:email=>@emails).map &:id
              when "sitevisit"
                @ids=SiteVisit.all.map {|a| a.commonplace_account_id}.uniq
              when "announcement"
                @ids=Announcement.where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @announcements=Announcement.where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
                @ids+=Feed.where(:id=>@announcements).map {|a|a.user_id}.uniq
              when "event"
                @ids=Event.where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @events=Event.where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
                @ids+=Event.where(:id=>@events).map {|a|a.user_id}.uniq
              when "reply"
                @ids = find_community.users.where("replies_count > 0").reorder("replies_count DESC")

                r = find_community.residents.where("user_id in (?)", @ids)

                return r
              when "replied"
                @postsids=Reply.all.map {|a| a.repliable_id}.uniq
                @ids=Post.where(:id=>@postsids).map {|a| a.user_id}.uniq
              when "invite"
                @ids=Invite.all.map {|a| a.inviter_id}.uniq
              when "story"
                @ids=Resident.where("stories_count > 0").map &:id
                @resident=true
            end
          when "flag"
            @resident=true

            residents = find_community.residents.all
            if haveornot == "yes"
              residents.reject! { |x| !x.tags.include?(@tag['tag']) }.map { |x| x.id }
            else
              residents.reject! { |x| x.tags.include?(@tag['tag']) }.map { |x| x.id }
            end

            r = find_community.residents.where("id in (?)", residents)

            return r
          when "interest"
            @ids=User.tagged_with(@tag['tag'],:on=>:interests).map {|a| a.id}.uniq
          when "type"
            @ids=Resident.tagged_with(@tag['tag'],:on=>:type_tags).map {|a| a.id}.uniq
            @resident=true
          when "sector"
            @ids=Resident.tagged_with(@tag['tag'],:on=>:sector_tags).map {|a| a.id}.uniq
            @resident=true
          when "organizer"
            @ids=Resident.tagged_with(@tag['tag'],:on=>:organizer).map {|a| a.id}.uniq
            @resident=true
        end
          @ids.uniq!
          if !@resident
            if haveornot=="yes"
              #for existing communities, not every user has a corresponding resident so i have
              #to joins resident in case of nil. But for new ones this is not necessary
              User.where(:id=>@ids,:community_id=>community_id).map &:resident
            else
              if @ids.empty?
                User.where(:community_id=>community_id).map &:resident
              else
                User.where("community_id = ? AND id not in (?)",community_id,@ids).map &:resident
              end
            end
          else
            if haveornot=="yes"
              Resident.where(:id=>@ids,:community_id=>community_id)
            else
              if @ids.empty?
                Resident.where(:community_id=>community_id)
              else
                Resident.where("community_id = ? AND id not in (?)",community_id,@ids)
              end
            end
          end
      end

      def filter_users_by_several_tag(tags,haves,community_id)
        @residents=filter_users_by_tag(tags[0],haves[0],community_id)
        @final=@residents&filter_users_by_tag(tags[1],haves[1],community_id)
        for @k in 2..tags.size-1 do
          @final=@final&filter_users_by_tag(tags[@k],haves[@k],community_id)
        end
        @final
      end

      def order_users_by_time_of_tag(tag,community_id,ids)
        @resident=false
        case tag
            when "post"
              if ids[:userids].size>0
                @ids=Post.where(:user_id=>ids[:userids]).order("created_at DESC").map {|a| a.user_id}.uniq
              else
                @ids=Post.order("created_at DESC").map {|a| a.user_id}.uniq
              end
            when "email"
              if ids[:userids].size>0
                @useremails=User.where(:id=>ids[:userids]).map &:email
                @emails=SentEmail.where(:status=>"opened", :recipient_email=>@useremails).sort("created_at DESC").map {|a| a.recipient_email}.uniq
                @ids=User.where(:email=>@emails).map &:id
              else
                @emails=SentEmail.where(:status=>"opened").sort("created_at DESC").map {|a| a.recipient_email}.uniq
                @ids=User.where(:email=>@emails).map &:id
              end
            when "sitevisit"
              if ids[:userids].size>0
                @ids=SiteVisit.where(:commonplace_account_id=>ids[:userids]).sort("created_at DESC").map {|a| a.commonplace_account_id}.uniq
              else
                @ids=SiteVisit.sort("created_at DESC").map {|a| a.commonplace_account_id}.uniq
              end
            when "announcement"
              @announcements=Announcement.order("created_at DESC").where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
              if ids[:userids].size>0
                @ids=Announcement.where(:owner_id=>ids[:userids],:owner_type=>"User").order("created_at DESC").map {|a| a.owner_id}.uniq
                @announcements=@announcements&@ids
                @ids+=Feed.where(:id=>@announcements).map {|a|a.user_id}.uniq
              else
                @ids=Announcement.order("created_at DESC").where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @ids+=Feed.where(:id=>@announcements).map {|a|a.user_id}.uniq
              end
            when "event"
              @events=Event.order("created_at DESC").where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
              if ids[:userids].size>0
                @ids=Event.where(:owner_type=>"User",:owner_id=>ids[:userids]).order("created_at DESC").map {|a| a.owner_id}.uniq
                @events=@events&@ids
                @ids+=Event.order("created_at DESC").where(:id=>@events).map {|a|a.user_id}.uniq
              else
                @ids=Event.order("created_at DESC").where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @ids+=Event.order("created_at DESC").where(:id=>@events).map {|a|a.user_id}.uniq
              end
            when "reply"
              if ids[:userids].size>0
                @ids=Reply.where(:user_id=>ids[:userids]).order("created_at DESC").map {|a| a.user_id}.uniq
              else
                @ids=Reply.order("created_at DESC").map {|a| a.user_id}.uniq
              end
            when "replied"
              @postsids=Reply.order("created_at DESC").map {|a| a.repliable_id}.uniq
              if ids[:userids].size>0
                @ids=Post.where(:user_id=>ids[:userids],:id=>@postsids).map {|a| a.user_id}.uniq
              else
                @ids=Post.where(:id=>@postsids).map {|a| a.user_id}.uniq
              end
            when "invite"
              if ids[:userids].size>0
                @ids=Invite.where(:inviter_id=>ids[:userids]).order("created_at DESC").map {|a| a.inviter_id}.uniq
              else
                @ids=Invite.order("created_at DESC").map {|a| a.inviter_id}.uniq
              end
            when "story"
              @resident=true
              if ids[:residentids].size>0
                @ids=Resident.where("last_story_time is not null AND id in (?)",ids[:residentids]).order("last_story_time DESC").map &:id
              else
                @ids=Resident.where("last_story_time is not null").order("last_story_time DESC").map &:id
              end
            else
              @resident=true
              if ids[:residentids].size>0
                @ids=Flag.where("name=? AND id in (?)",tag,ids[:residentids]).order("created_at DESC").map &:resident_id
              else
                @ids=Flag.where(:name=>tag).order("created_at DESC").map &:resident_id
              end
            end
          @ids.uniq!
          @residents=nil
          if !@resident
              # for existing communities, not every user has a corresponding resident so i have
              # to joins resident in case of nil. But for new ones this is not necessary, remove it to
              # improve speed
            @residents=User.where(:id=>@ids[0],:community_id=>community_id).map &:resident
            for @k in 1..@ids.size-1 do
              if @users=User.where(:id=>@ids[@k],:community_id=>community_id)
                @users.each do |user|
                  @residents << user.resident
                end
              end
            end
          else
            @residents=Resident.where(:id=>@ids[0],:community_id=>community_id)
            for @k in 1..@ids.size-1 do
              if @r=Resident.where(:id=>@ids[@k],:community_id=>community_id)
                @r.each do |r|
                  @residents << r
                end
              end
            end
          end
          @residents.uniq!
          serialize(@residents)
      end

      def order_users_by_quantity_of_tag(tag,community_id,ids)
        @resident=false
        # for existing communities, not every user has a corresponding resident so i have
        # to joins resident in case of nil. But for new ones this is not necessary, now i remove it to
        # improve speed. If needed add it back. e.g. @residents=User.where("users.id in (?) AND residents.community_id = ?
        # AND users.posts_count <> ?",ids[:userids],community_id,0).order("posts_count DESC").map &:resident
        #                                                                          --   Ye Shen
        case tag
          when "post"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? AND users.posts_count <> ?",ids[:userids],community_id,0).order("posts_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.posts_count <> ?",community_id,0).order("posts_count DESC").map &:resident
            end
          when "reply"
            if ids[:userids].size > 0
              @residents = User.where("users.id in (?)",ids[:userids]).order("replies_count DESC").map &:resident
            else
              @residents = User.where("residents.community_id = ? and users.replies_count <> ?",community_id,0).order("replies_count DESC").map &:resident
            end
          when "sitevisit"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? AND users.sign_in_count <> ?",ids[:userids],community_id,0).order("sign_in_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.sign_in_count <> ?",community_id,0).order("sign_in_count DESC").map &:resident
            end
          when "announcement"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? and users.announcements_count <> ?",ids[:userids],community_id,0).order("announcements_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.announcements_count <> ?",community_id,0).order("announcements_count DESC").map &:resident
            end
          when "feed"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? and users.feeds_count <> ?",ids[:userids],community_id,0).order("feeds_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.feeds_count <> ?",community_id,0).order("feeds_count DESC").map &:resident
            end
          when "replied"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? and users.replied_count <> ?",ids[:userids],community_id,0).order("replied_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.replied_count <> ?",community_id,0).order("replied_count DESC").map &:resident
            end
          when "invite"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? and users.invite_count <> ?",ids[:userids],community_id,0).order("invite_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.invite_count <> ?",community_id,0).order("invite_count DESC").map &:resident
            end
          when "event"
            if ids[:userids].size>0
              @residents=User.where("users.id in (?) AND residents.community_id = ? and users.event_count <> ?",ids[:userids],community_id,0).order("events_count DESC").map &:resident
            else
              @residents=User.where("residents.community_id = ? and users.event_count <> ?",community_id,0).order("events_count DESC").map &:resident
            end
          when "story"
            if ids[:residentids].size>0
              @residents=Resident.where("id in (?) and community_id = ? and stories_count <> ?",ids[:residentids],community_id,0).order("stories_count DESC")
            else
              @residents=Resident.where("community_id = ? and stories_count <> ?",community_id,0).order("stories_count DESC")
            end
        end
        @residents.uniq!
        serialize(@residents)
      end
    end

    # Returns the serialized community, found by slug or id
    get "/:id" do
      control_access :public

      serialize find_community
    end

    # Set organize start date
    post "/:id" do
      control_access :admin

      Community.find(params[:id]).update_attributes(:organize_start_date=>request_body['organize_start_date'])
    end

    # Returns the serialized community wire
    #
    # Requires community membership
    get "/:id/wire" do
      control_access :community_member, find_community

      serialize find_community.wire
    end

    # Returns the community's residents list
    #
    # Requires community membership
    #
    # Query params:
    #   query - query to search residents by
    #   limit - the page limit
    #   page - the page
    get "/:id/residents" do
      control_access :community_member, find_community

      residents = find_community.residents.includes(:user)
      residents = paginate(residents)
      residents = residents.order("first_name ASC, last_name ASC")
      if params["query"].present?
        terms = params["query"].split(" ").join(" | ")
        residents = residents.where(<<CONDITION,terms)
upper(first_name || ' ' || last_name)::tsvector @@ tsquery(upper(?))
CONDITION
      end
      serialize residents
    end

    # Returns the community's feeds, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/org_feeds" do
      control_access :admin

      if params["query"].present?
        search(Feed, params, find_community.id)
      else
        scope = find_community.feeds.reorder("name ASC")
        serialize(paginate(scope).page(params[:page]).per(params[:per]))
      end
    end

    # Transfers feed ownership
    post "/:id/org_feeds/:feed_id/transfer" do
      feed = find_community.feeds.find(params[:feed_id])
      new_owner = find_community.users.find_by_email(params[:new_owner])

      if !new_owner.nil?
        old_owner = feed.user
        f_owner = feed.feed_owners.find_by_user_id(old_owner.id)
        f_owner.user = new_owner
        f_owner.save!

        feed.user =new_owner
        feed.save!
      else
        [400, "errors"]
      end
    end

    # Returns community's resident files
    #
    # Requires admin
    #
    # I really think it gonna be much faster if change to executing SQL. So hope you have time change to SQL --Ye Shen
    get "/:id/files" do
      control_access :admin

      if params[:search] == "search"
        text = params[:text]

        case params[:type]
        when "email"
          r = find_community.residents.where("email ILIKE ?", "%#{text}%")
        when "address"
          r = find_community.residents.where("address ILIKE ?", "%#{text}%")
        when "notes"
          r = find_community.residents.where("notes ILIKE ?", "%#{text}%")
        when "first name"
          r = find_community.residents.where("first_name ILIKE ?", "%#{text}%")
        when "last name"
          r = find_community.residents.where("last_name ILIKE ?", "%#{text}%")
        else
          r = find_community.residents.find_by_full_name(text)
        end

        return serialize(paginate(r).page(params[:page]).per(params[:per]))
      end


      if params[:search]=="filter"
        if !params[:order]
          if params[:tag].nil? || params[:tag].length == 0
            r = Resident.where(:community_id=>params[:id])

            if params[:count]
              serialize(r.count)
            else
              serialize(paginate(r).page(params[:page]).per(params[:per]).order("last_name ASC, first_name ASC"))
            end
          elsif params[:tag].length > 1
            r = filter_users_by_several_tag(params[:tag],params[:have],params[:id])

            if params[:count]
              serialize(r.count)
            else
              r.map! { |res| res.id }
              s = Resident.where("id in (?)", r)

              serialize(paginate(s).page(params[:page]).per(params[:per]).order("last_name ASC, first_name ASC"))
            end
          else
            r = filter_users_by_tag(params[:tag][0], params[:have][0], params[:id])

            if params[:count]
              serialize(r.count)
            else

              serialize(paginate(r).page(params[:page]).per(params[:per]).order("last_name ASC, first_name ASC"))
            end
          end
        else
          if params[:order] == "time"
            order_users_by_time_of_tag(params[:tag],params[:id],params[:ids])
          else
            order_users_by_quantity_of_tag(params[:tag],params[:id],params[:ids])
          end
        end
      elsif params[:search] == "byinterest"
        serialize(User.where(:community_id=>params[:id]).tagged_with(params[:tag],:on=>:interests).map &:resident)
      elsif params[:search] == "linked"
        if params[:resident_id]
          serialize(User.find(Resident.find(params[:resident_id]).user_id).find_related_interests.map &:resident)
        else
          serialize(User.find(params[:user_id]).find_related_interests.map &:resident)
        end
      else
        r = Resident.where(:community_id=>params[:id])

        if params[:count]
          serialize(r.count)
        else
          serialize(paginate(r).page(params[:page]).per(params[:per]).order("last_name ASC, first_name ASC"))
        end
      end
    end

    # Gets various statistics on people for graph usage
    # Depends on the demands of the organizing team
    get "/:id/user_stats" do
      control_access :admin

      find_community.user_statistics.to_json
    end

    # Gets various statistics on people for chart usage
    # Depends on the demands of the organizing team
    get "/:id/user_charts" do
      control_access :admin

      find_community.user_charts.to_json
    end

    get "/:id/subscribers" do
      control_access :admin

      Feed.find(params[:id]).subscribers.to_json
    end

    # Add a new resident
    #
    # Requires admin
    #
    post "/:id/files/newresident" do
      control_access :admin

      r = find_community.residents.create(:first_name => request_body['first_name'],
                                      :last_name => request_body['last_name'],
                                      :email => request_body['email'],
                                      :phone => request_body['phone'],
                                      :organization => request_body['organization'],
                                      :position => request_body['position'],
                                      :notes => request_body['notes'],
                                      :address => request_body['address'],
                                      :sector_tag_list => request_body['sector_tag_list'],
                                      :type_tag_list => request_body['type_tag_list'],
                                      :PFO_statu_list => request_body['PFO_statu_list'],
                                      :organizer_list => request_body['organizer_list'],
                                      :input_method_list => request_body['input_method_list'],
                                      :manually_added => true)

      r.correlate
    end

    # Updates a community resident file
    #
    # Requires admin
    #
    # Request params:
    #   email - set the file's email to this (optional)
    #   address - set the files address to this (optional)
    put "/:id/files/:file_id" do
      control_access :admin

      Resident.find(params[:file_id]).update_attributes(
        request_body.slice("email", "address","phone","organization","notes","position","first_name","last_name","sector_tag_list","type_tag_list","input_method_list","PFO_statu_list","organizer_list")      )
    end

    # Returns a specific resident file
    #
    # This is being called somewhere in the organizer app,
    # though I'm not sure where.
    # This is here to stop the 404 error, though it seems like
    # a harmless error
    get "/:id/files/:file_id" do
      control_access :admin

      Resident.find(params[:file_id])
    end

    # Returns related users of specific resident file
    # according to interests
    get "/:id/files/:file_id/relatedusers" do
      control_access :admin
      user_id=Resident.find(params[:file_id]).user_id
      user=User.find(user_id)
      serialize(user.find_related_interests)

    end

    # Add a log to a community resident file
    #
    # Requires admin
    #
    # Request params:
    #   date - the date the logged activity occured on
    #   text - the activity description
    #   tags - any tags related to the log
    post "/:id/files/:file_id/logs" do
      control_access :admin

      Resident.find(params[:file_id]).add_log(
        request_body['date'],
        request_body['text'],
        [])
      200
    end

    # Add tags to community resident files
    #
    # Requires admin
    #
    # Request params:
    #   tags - the tags to add
    post "/:id/files/tags" do
      control_access :admin

      params[:file_id].each do |id|
        find_community.residents.find(id).add_tags(params[:tags])
      end

      200
    end

    # Merges two resident files
    #
    # This should only be done if someone notices that
    # two files are the same person
    #
    # requires admin
    post "/:id/files/merge" do
      merger = find_community.residents.find(params[:merger])
      mergee = find_community.residents.find(params[:mergee])

      if merger.flags.count > mergee.flags.count
        mergee.merge_into(merger)
        mergee.destroy
      else
        merger.merge_into(mergee)
        merger.destroy
      end
    end

    # Tags all filtered resident files with given tag
    #
    # Requires admin
    post "/:id/files/tag_all" do
      control_access :admin

      if params[:tag].length > 1
        res = filter_users_by_several_tag(params[:tag],params[:have],params[:id])
      elsif params[:tag].length == 1
        res = filter_users_by_tag(params[:tag][0], params[:have][0], params[:id])
      elsif params[:tag].length == 0
        [200, {}, "0"]
      end
      res.sort!

      per = params[:per].to_i
      start = per * (params[:page].to_i - 1)
      partial = res.slice(start, per)
      partial.each do |r|
        r.add_tags(params[:add])
      end

      [200, {}, "#{res.count}"]
    end

    # Create a post in the community
    #
    # Requires community membership
    #
    # Request params:
    #   title - the post subject
    #   body - the post body
    #   category - the post category
    #
    # When successful we kick off a notification job and return
    # the serialized post
    # When unsuccessful we return a 400 response
    post "/:id/posts" do
      control_access :community_member, find_community

      post = Post.new(:user => current_user,
                      :community_id => find_community.id,
                      :subject => request_body['title'],
                      :body => request_body['body'],
                      :category => request_body["category"])
      if post.save
        kickoff.deliver_post(post)
        serialize(post)
      else
        [400, "errors"]
      end
    end

    # Create a announcement in the community
    #
    # Requires community membership
    #
    # Request params:
    #   title - the announcement subject
    #   body - the announcement body
    #   group_ids - the announcement groups
    #   feed - the feed that is creating the announcement
    #
    # When successful we kick off a notification job and return
    # the serialized announcement
    # When unsuccessful we return a 400 response
    post "/:id/announcements" do
      control_access :community_member, find_community

      announcement = Announcement.new(:owner => Feed.find(request_body['feed']),
                                      :subject => request_body['title'],
                                      :body => request_body['body'],
                                      :community_id => find_community.id,
                                      :group_ids => request_body["groups"])

      if announcement.save
        kickoff.deliver_announcement(announcement)
        serialize(announcement)
      else
        [400, "errors"]
      end
    end

    # Create an event in the community
    #
    # Requires community membership
    #
    # Request params:
    #   title - the event name
    #   about - the event description
    #   date - the event date
    #   start_time - when it starts (optional)
    #   end_time - when it ends (optional)
    #   venue - where it is (optional)
    #   address - street address (optional)
    #   tag_list - tags (optional)
    #   group_ids - relevant groups (optional)
    #
    # Returns serialized event if save is succesfull
    # Returns 400 if unsuccessfull

    post "/:id/events" do
      control_access :community_member, find_community

      event = Event.new(:owner => current_user,
                        :name => request_body['title'],
                        :description => request_body['body'],
                        :date => request_body['date'],
                        :start_time => request_body['starts_at'],
                        :end_time => request_body['ends_at'],
                        :venue => request_body['venue'],
                        :address => request_body['address'],
                        :tag_list => request_body['tags'],
                        :community_id => find_community.id,
                        :group_ids => request_body['groups']
      )
      if event.save
        serialize(event)
      else
        [400, "errors"]
      end
    end

    # Requires community membership
    #
    # Creates a new Transaction model
    post "/:id/transactions" do
      control_access :community_member, find_community

      transaction = Transaction.new(
        :community_id => find_community.id,
        :seller => current_user,
        :title => request_body['title'],
        :price_in_cents => request_body['price'],
        :description => request_body['body']
      )

      if transaction.save
        serialize(transaction)
      else
        [400, "errors"]
      end
    end

    # Logs who's interested in a given transaction
    post "/:trans_id/buy_log" do
      t = Transaction.find(params[:trans_id])

      t.add_buyer(params[:buyer])
    end

    # Returns a list of completed versions of community names
    #
    # Note: This should not be bound to a community, but when
    # the /:id is left out, this function isn't recognized and
    # won't be called. As a "fix" to this, one can use any of
    # the existing communities' id/name to call this function
    # eg: /api/lexington/comm_completions
    #
    # Maybe it has something to do with the way the API is set up?
    get "/:id/comm_completions" do
      comm = Community.where("(name || ', ' || state) ILIKE ?", "%#{params[:term]}%").sort_by(&:name)

      slim = comm.map { |c| {name: c.name, slug: c.slug, state: c.state} }

      return slim.to_json
    end

    # For auto-complete
    get "/:id/comm_complete" do
      comm = Community.where("(name || ', ' || state) ILIKE ?", "%#{params[:term]}%")

      full_comm = comm.map { |c| "#{c.name}, #{c.state}" }.sort
      return serialize(full_comm)
    end

    # Returns a list of completed versions of the address
    #
    # term - the term to find auto-completed
    get "/:id/address_completions" do
      if !find_community.street_addresses.nil? && find_community.street_addresses.count > 0
        addr = find_community.street_addresses.where("address ILIKE ?", "%#{params[:term]}%").pluck(:address)

        serialize(addr[0, 7])
      else
        addr = find_community.residents.where("address ILIKE ?","%#{params[:term]}%").pluck(:address)

        serialize(addr[0,7])
      end
    end

    # Returns a list of address approximations
    #
    # term - the address to match with
    # TODO: Instead of loosening the similarity cut-off,
    # make sure they type in a "proper" address (ie begins with some #)
    get "/:id/address_approximate" do
      if find_community.nil? || Community.find_by_name("Lexington").nil?
        return serialize([-1])
      end
      if find_community.launch_date.to_date < Community.find_by_name("Lexington").launch_date.to_date
        return serialize([-1])
      end
      if params[:term].nil? || params[:term].empty?
        return serialize([])
      end

      input = params[:term].split(",").first
      likeness = input.split(" ").first =~ /^[0-9]+/ ? 0.84 : 0.84
      addr = {}
      best = 0

      if !find_community.street_addresses.nil? && find_community.street_addresses.count > 0
        find_community.street_addresses.each do |street_address|
          street = street_address.address.squeeze(" ").strip
          test = street.jarowinkler_similar(input.squeeze(" ").strip)

          if test == 1
            best = test
            addr[street] = test
            break
          end

          st_apt = street.clone
          st_apt << " Apt" if !street.upcase.include?("APT")
          test = st_apt.jarowinkler_similar(input.squeeze(" ").strip)
          if test > best
            best = test
          end
          if test >= likeness
            addr[street] = test
          end
        end
      else
        find_community.residents.each do |street_address|
          next if street_address.address.nil? || street_address.address.empty?
          street = street_address.address.squeeze(" ").split(",").first.strip
          test = street.jarowinkler_similar(input.squeeze(" ").strip)

          if test == 1
            best = test
            addr[street] = test
            break
          end


          st_apt = street.clone
          st_apt << " Apt" if !street.upcase.include?("APT")
          test = st_apt.jarowinkler_similar(input.squeeze(" ").strip)
          if test > best
            best = test
          end
          if test >= likeness
            addr[street] = test
          end
        end
      end

      list = addr.sort {|a, b| b[1] <=> a[1]}.map {|a, b| a}
      threshold_test = [best, list[0]]
      serialize(threshold_test)
    end

    # Returns the community's posts, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/posts" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Post)

      if params["query"].present?
        chronological_search(Post, params, find_community.id)
      else
        serialize(paginate(find_community.posts.includes(:user, :replies)))
      end
    end

    # Returns the community's posts and group_posts, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/posts_and_group_posts" do
      control_access :community_member, find_community

      if params["query"].present?
        chronological_search([Post, GroupPost], params, find_community.id)
      else
        chronological([Post, GroupPost], params, find_community.id)
      end
    end

    # Returns the community's posts in a category, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/posts/:category" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Post)

      if params["query"].present?
        chronological_search(Post, params, find_community.id) do |search|
          search.with(:category, params[:category])
        end
      else
        serialize(paginate(
            find_community.posts.
            where(:category => params[:category]).
            includes(:user, :replies)
            ))
      end
    end

    # Returns the community's events, possibly a search result
    get "/:id/events" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Event)

      if params["query"].present?
        event_search(params, find_community.id) do |search|
          search.with(:date).greater_than(Time.now.beginning_of_day)
        end
      else
        serialize(paginate(find_community.events.upcoming.
                             includes(:replies).reorder("date ASC")))
      end
    end

    # Returns the community's transactions, possibly a search result
    get "/:id/transactions" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Transaction)

      if params["query"].present?
        chronological_search(Transaction, params, find_community.id)
      else
        serialize(paginate(find_community.transactions).reorder("created_at DESC"))
      end
    end

    # Returns the community's announcements, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/announcements" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Announcement)

      if params["query"].present?
        chronological_search(Announcement, params, find_community.id)
      else
        serialize(paginate(find_community.announcements.
                             includes(:replies, :owner).
                             reorder("GREATEST(replied_at,created_at) DESC")))
      end
    end

    # Returns the community's group posts, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/group_posts" do
      control_access :community_member, find_community

      last_modified_by_replied_at(GroupPost)

      if params["query"].present?
        chronological_search(GroupPost, params, find_community.id)
      else
        serialize(paginate(GroupPost.order("group_posts.updated_at DESC").
                             includes(:group, :user).
                             where(:groups => {:community_id => find_community.id})))
      end
    end

    # Returns the community's feeds, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/feeds" do
      control_access :community_member, find_community

      if params["query"].present?
        search(Feed, params, find_community.id)
      else
        scope = find_community.feeds.reorder("name ASC")
        serialize(paginate(scope))
      end
    end

    # Returns the community's groups, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/groups" do
      control_access :community_member, find_community

      if params["query"].present?
        search(Group, params, find_community.id)
      else
        serialize(paginate(find_community.groups.reorder("name ASC")))
      end
    end

    # Returns the community's users, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/users" do
      control_access :community_member, find_community

      if params["query"].present?
        if current_user.admin
          auth_search(User, params) # what is auth_search for ?
        else
          search(User, params, find_community.id)
        end
      else
        scope = find_community.users.reorder("last_name ASC, first_name ASC")
        serialize(paginate(scope))
      end
    end

    # Returns the community's featured feeds
    get "/:id/feeds/featured" do
      control_access :community_member, find_community

      scope = find_community.feeds.featured.order("name ASC")
      serialize paginate(scope)
    end

    # Returns the community's user count
    get "/:id/user_count" do
      control_access :community_member, find_community

      serialize(find_community.users.count)
    end

    # Returns all [Feed, Group]s
    #
    # Query params:
    #   query = the query to search with
    get "/:id/group-like" do
      control_access :community_member, find_community

      if params['query'].present?
        search([Feed, Group], params, find_community.id)
      else
        list_all([Feed, Group], params, find_community.id)
      end
    end

    # Gets all postlikes for a community, possibly a search
    #
    # Query params:
    #   query = the query to search with (optional)
    get "/:id/post-like" do
      control_access :community_member, find_community

      if params["query"].present?
        chronological_search([Announcement, Event, Post, GroupPost, Transaction], params, find_community.id)
      else
        chronological([Announcement, Event, Post, GroupPost, Transaction], params, find_community.id)
      end
    end

    # Sends an invite
    #
    # Request params:
    #   emails - Emails to invite
    #   message - A personal message to send
    post "/:id/invites" do
      control_access :community_member, find_community

      kickoff.deliver_user_invite(request_body['emails'],
                                  current_user,
                                  request_body['message'])
      [ 200, {}, "" ]
    end

    # Sends a share
    #
    # Request params:
    #   data_type - shared Postlike class
    #   id - id of the shared Postlike
    #   email - email to share to
    post "/:id/shares" do
      control_access :community_member, find_community

      scope = request_body['data_type'].chop.camelize.constantize
      item = scope.find(request_body['id'])
      kickoff.deliver_share_notification(current_user, item, request_body['email'])
      [ 200, {}, "" ]
    end

    # Sends a question to us
    #
    # Request params:
    #  email - email of the question asker
    #  message - the question
    #  name - name of the question asker
    post "/:id/questions" do
      control_access :community_member, find_community

      kickoff.deliver_admin_question(request_body['email'],
                                     request_body['message'],
                                     request_body['name'])
      [ 200, {}, "" ]
    end

  end
end
