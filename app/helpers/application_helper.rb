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

  if (CommonPlace.community_attrs){
    mpq.register({'community': CommonPlace.community_attrs.slug});
  }

  if (CommonPlace.account_attrs){
    mpq.identify(CommonPlace.account_attrs.email);
    mpq.register({'email': CommonPlace.account_attrs.email,
                  'referral_source': CommonPlace.account_attrs.referral_source});
    mpq.name_tag(CommonPlace.account_attrs.name + ' - ' + CommonPlace.account_attrs.email);
  }
}
//]]>
</script>
script
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
    community = ''
    account = ''

    if current_community
      community << "CommonPlace.community_attrs = #{serialize(current_community)};\n"
      community << "if (window.Community) CommonPlace.community = new Community(CommonPlace.community_attrs);"
    end
    if current_user
      account << "CommonPlace.account_attrs = #{serialize(Account.new(current_user))};\n"
      account << "if (window.Account) CommonPlace.account = new Account(CommonPlace.account_attrs);"
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
