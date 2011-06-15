require 'spec_helper'

describe RSSImporter do
  context "given an RSS element from Feedburner" do
    it "strips the FeedFlare" do
      html = '<p class="MsoNormal" style="margin: 0in 0in 10pt;"><span lang="EN" style="line-height: 115%; font-family: &quot;Arial&quot;, &quot;sans-serif&quot;; font-size: 12pt; mso-bidi-font-size: 11.0pt; mso-ansi-language: EN;">LANSING \342\200\224 The state\'s popular Pure Michigan tourism campaign has gotten a $3 million boost from private-sector partners to support advertising this year.<br /><br />The Travel Michigan Ad Partnership Program announced Monday that the contributions from 28 communities and destinations in Michigan are double those from 2010. The Michigan Economic Development Corp. is matching those contributions.<br /><br />The Henry Ford in Dearborn and visitors bureaus in Traverse City and Mackinac Island are national sponsors, each contributing $500,000 toward the Pure Michigan national campaign. Travel Michigan says the money means ads will be able to run longer on cable television networks nationwide.<br /><br />Pure Michigan campaigns promote the state\'s beaches, golf courses and other destinations to potential tourists.<o:p></o:p></span></p><div class="feedflare">\n<a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:yIl2AUoC8zA"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=yIl2AUoC8zA" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:V_sGLiPBpWU"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?i=TLKen1QI3lU:Xo_UPvx6M1s:V_sGLiPBpWU" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:qj6IDK7rITs"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=qj6IDK7rITs" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:l6gmwiTKsz0"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=l6gmwiTKsz0" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:gIN9vFwOqvQ"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?i=TLKen1QI3lU:Xo_UPvx6M1s:gIN9vFwOqvQ" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:TzevzKxY174"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=TzevzKxY174" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:-BTjWOF_DHI"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?i=TLKen1QI3lU:Xo_UPvx6M1s:-BTjWOF_DHI" border="0"></img></a>\n</div><img src="http://feeds.feedburner.com/~r/LakeSuperiorCommunityPartnershipNews/~4/TLKen1QI3lU" height="1" width="1"/>'
      intended_html = '<p class="MsoNormal" style="margin: 0in 0in 10pt;"><span lang="EN" style="line-height: 115%; font-family: "Arial", "sans-serif"; font-size: 12pt; mso-bidi-font-size: 11.0pt; mso-ansi-language: EN;">LANSING \342\200\224 The state\'s popular Pure Michigan tourism campaign has gotten a $3 million boost from private-sector partners to support advertising this year.<br /><br />The Travel Michigan Ad Partnership Program announced Monday that the contributions from 28 communities and destinations in Michigan are double those from 2010. The Michigan Economic Development Corp. is matching those contributions.<br /><br />The Henry Ford in Dearborn and visitors bureaus in Traverse City and Mackinac Island are national sponsors, each contributing $500,000 toward the Pure Michigan national campaign. Travel Michigan says the money means ads will be able to run longer on cable television networks nationwide.<br /><br />Pure Michigan campaigns promote the state\'s beaches, golf courses and other destinations to potential tourists.<o:p></o:p></span></p><img src="http://feeds.feedburner.com/~r/LakeSuperiorCommunityPartnershipNews/~4/TLKen1QI3lU" height="1" width="1"/>'

      RSSImporter.strip_feedflare(html).should == intended_html
    end
  end

  context "given an RSS element from anywhere else" do
    it "should not modify the HTML" do
      html = '<p class="MsoNormal" style="margin: 0in 0in 10pt;"><span lang="EN" style="line-height: 115%; font-family: &quot;Arial&quot;, &quot;sans-serif&quot;; font-size: 12pt; mso-bidi-font-size: 11.0pt; mso-ansi-language: EN;">LANSING \342\200\224 The state\'s popular Pure Michigan tourism campaign has gotten a $3 million boost from private-sector partners to support advertising this year.<br /><br />The Travel Michigan Ad Partnership Program announced Monday that the contributions from 28 communities and destinations in Michigan are double those from 2010. The Michigan Economic Development Corp. is matching those contributions.<br /><br />The Henry Ford in Dearborn and visitors bureaus in Traverse City and Mackinac Island are national sponsors, each contributing $500,000 toward the Pure Michigan national campaign. Travel Michigan says the money means ads will be able to run longer on cable television networks nationwide.<br /><br />Pure Michigan campaigns promote the state\'s beaches, golf courses and other destinations to potential tourists.<o:p></o:p></span></p><div class="feedflare">\n<a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:yIl2AUoC8zA"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=yIl2AUoC8zA" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:V_sGLiPBpWU"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?i=TLKen1QI3lU:Xo_UPvx6M1s:V_sGLiPBpWU" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:qj6IDK7rITs"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=qj6IDK7rITs" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:l6gmwiTKsz0"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=l6gmwiTKsz0" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:gIN9vFwOqvQ"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?i=TLKen1QI3lU:Xo_UPvx6M1s:gIN9vFwOqvQ" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:TzevzKxY174"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?d=TzevzKxY174" border="0"></img></a> <a href="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?a=TLKen1QI3lU:Xo_UPvx6M1s:-BTjWOF_DHI"><img src="http://feeds.feedburner.com/~ff/LakeSuperiorCommunityPartnershipNews?i=TLKen1QI3lU:Xo_UPvx6M1s:-BTjWOF_DHI" border="0"></img></a>\n</div><img src="http://feeds.feedburner.com/~r/LakeSuperiorCommunityPartnershipNews/~4/TLKen1QI3lU" height="1" width="1"/>'

      RSSImporter.strip_feedflare(html).should == html
    end
  end
end
