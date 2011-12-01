module ApplicationHelper

  def tab_to(name, options = {}, html_options = {}, &block)
    options, html_options = name, options if block

    html_options[:class] ||= ""
    if current_page?(options) || current_page?(url_for(options) + ".json")
      html_options[:class] += " selected_nav"
    end
    if block
      link_to(options, html_options, &block)
    else
      link_to(name, options, html_options)
    end
  end

  def include_dummy_console
    raw <<script
<script type='text/javascript'>
//<![CDATA[
if (window['console'] == undefined || window.console['log'] == undefined){
  window.console = {
    log: function(){},
    warn: function(){},
    count: function(){},
    trace: function(){},
    info: function(){}
  };
}
//]]>
</script>
script
  end

  def include_mixpanel
    key = Rails.env.production? ? $MixpanelAPIToken : 'staging/testing key'
    raw <<script
<script type='text/javascript'>
//<![CDATA[
if (window['mpq'] != 'undefined'){
  var mpq = [];
  mpq.push(["init", "#{$MixpanelAPIToken}"]);
  (function(){var b,a,e,d,c;b=document.createElement("script");b.type="text/javascript";b.async=true;b.src=(document.location.protocol==="https:"?"https:":"http:")+"//api.mixpanel.com/site_media/js/api/mixpanel.js";a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(b,a);e=function(f){return function(){mpq.push([f].concat(Array.prototype.slice.call(arguments,0)))}};d=["init","track","track_links","track_forms","register","register_once","identify","name_tag","set_config"];for(c=0;c<d.length;c++){mpq[d[c]]=e(d[c])}})();
}
//]]>
</script>
script
  end

  def mixpanel_track(action, options = {})
    options.reverse_merge!(community: current_community.try(:slug))
    if Rails.env.production?
      raw <<END
<script type="text/javascript">
  mpq.track("#{action}", #{ options.to_json  });
</script>
END
    end
  end

  def include_ga
    key = Rails.env.production? ? 'UA-12807510-2' : 'staging/testing key'
    raw <<script
<script type='text/javascript'>
//<![CDATA[
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-12807510-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
//]]>
</script>
script
  end

  def include_exceptional
    key = Rails.env.production? ? '0556a141945715c3deb50a0288ec3bea5417f6bf' : 'staging/testing key'
    raw <<script
<script type='text/javascript' src="https://exceptional-js.heroku.com/exceptional.js"></script>
<script type='text/javascript'>
//<![CDATA[
if(window['Exceptional'] !== undefined){
  Exceptional.setHost('exceptional-api.heroku.com');
  Exceptional.setKey('#{key}');
}
//]]>
</script>
script
  end

  def include_commonplace(title = '')
    raw <<script
<script type='text/javascript'>
//<![CDATA[
  if(window['CommonPlace'] == undefined){
    CommonPlace = {};
  }
  CommonPlace.auth_token = "#{form_authenticity_token}";
  CommonPlace.env = '#{Rails.env}';
  CommonPlace.page = '#{title}';
//]]>
</script>
script
  end

  def populate_commonplace
    community = account = ''

    if current_user
      account << "CommonPlace.account = new Account(#{serialize(Account.new(current_user))});"
      community << "CommonPlace.community = new Community(#{serialize(current_community)});"
    end

      raw <<script
<script type='text/javascript'>
//<![CDATA[
$(document).ready(function(){
  #{account}
  #{community}
});
//]]>
</script>
script
  end

end
