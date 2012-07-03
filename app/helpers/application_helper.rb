module ApplicationHelper

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

  def include_kissmetrics
    key = Rails.env.production? ? $KissmetricsAPIToken : 'staging/testing key'
    raw <<script
<script type="text/javascript">
  var _kmq = _kmq || [];
  var _kmk = _kmk || '#{key}';
  function _kms(u){
    setTimeout(function(){
      var d = document, f = d.getElementsByTagName('script')[0],
      s = d.createElement('script');
      s.type = 'text/javascript'; s.async = true; s.src = u;
      f.parentNode.insertBefore(s, f);
    }, 1);
  }
  _kms('//i.kissmetrics.com/i.js');
  _kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');
</script>
script
  end

  def kissmetrics_track_person(user)
    if Rails.env.production?
      raw <<script
<script type="text/javascript">
_kmq.push(['identify', '#{user.email}']);
</script>
script
    end
  end

  def include_mixpanel
    key = Rails.env.production? ? $MixpanelAPIToken : 'staging/testing key'
    raw <<script
<script type="text/javascript">(function(c,a){var b,d,h,e;b=c.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===c.location.protocol?"https:":"http:")+'//api.mixpanel.com/site_media/js/api/mixpanel.2.js';d=c.getElementsByTagName("script")[0];d.parentNode.insertBefore(b,d);a._i=[];a.init=function(b,c,f){function d(a,b){var c=b.split(".");2==c.length&&(a=a[c[0]],b=c[1]);a[b]=function(){a.push([b].concat(Array.prototype.slice.call(arguments,0)))}}var g=a;"undefined"!==typeof f?g=
a[f]=[]:f="mixpanel";g.people=g.people||[];h="disable track track_pageview track_links track_forms register register_once unregister identify name_tag set_config people.set people.increment".split(" ");for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.1;window.mixpanel=a})(document,window.mixpanel||[]);
mixpanel.init("#{key}");</script>
script
  end

  def mixpanel_track_person(user)
    if Rails.env.production?
      raw <<END
<script type="text/javascript">
mixpanel.identify('#{user.id}');
mixpanel.people.set({
    "$email": "#{user.email}", // Only special properties need the $.
    "$created": "#{user.created_at}",
    // Feel free to define your own:
    "community": "#{user.community.slug}",
    "receive_daily_bulletins": #{user.receive_weekly_digest},
    "referral_source": "#{user.referral_source}",
    "last_login_at": "#{user.last_login_at}",
    "referral_metadata": "#{user.referral_metadata}",
    "sign_in_count": #{user.sign_in_count || 0},
    "calculated_cp_credits": #{user.calculated_cp_credits || 0},
    "number_of_organizations": #{user.organizations.count}
});
</script>
END
  end
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

end
