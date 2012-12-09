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
