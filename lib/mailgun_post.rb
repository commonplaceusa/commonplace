class MailgunPost

  def initialize(params)
    @params = params
  end

  def to
    @to ||= Mail::Address.new(@params['recipient']).address.slice(/^[^@]*/)
  end

  def from
    @from ||= Mail::Address.new(@params['from']).address
  end

  def personalized_filters
    {
      "dwayne.patterson@raleighnc.gov" => lambda do |text| 
        text.match(/<div class=Section1>(.*?)<div>/m)[1].
          gsub(/<.*?>/m,"").
          gsub("&nbsp;","").
          gsub("&#8217;", "'").
          gsub(/\n\n\n*/,"\n\n")
      end
    }
  end

  def save
    self.create_reply
  end

  def create_reply
    if reply = Reply.create!(
        repliable: Repliable.find(self.to.match(/reply\+([a-zA-Z_0-9]+)/)[1]),
        body: self.body_text,
        user: self.user)
      KickOff.new.deliver_reply(reply)
    end
  end

  def user
    @user ||= User.find_by_email(from)
  end

  def body_text
    @body_text ||=
      if self.personalized_filters.has_key?(from)
        self.personalized_filters[from].call(@params['body-html'])
      else
        self.strip_email_body(@params['stripped-text'])
      end
  end

  def out_of_office_regexp
    %r{(out\ of\ office)
      |(out\ of\ the\ office)}xi
  end

  def filter_out_of_office
    if @params['stripped-text'].match(out_of_office_regexp)
      render :nothing => true
      return false
    end
  end

  def strip_email_body(text)
    text.split(%r{(^-- \n) # match standard signature
                 |(^--\n) # match non-stantard signature
                 |(^-----Original\ Message-----) # Outlook
                 |(^----- Original\ Message -----) # Outlook
                 |(^________________________________) # Outlook
                 |(-*\ ?Original\ Message\ ?-*) # Generic
                 |(On.*wrote:) # OS X Mail.app
                 |(From:\ ) # Outlook and some others
                 |(Sent\ from) # iPhone, Blackberry
                 |(In\ a\ message\ dated.*,)
                 }x).first
  end

end
