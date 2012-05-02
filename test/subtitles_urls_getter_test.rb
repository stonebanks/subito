# -*- coding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock/test_unit'
require 'subito/sub_site_crawler'
require 'fakeweb'

include Subito

class TestSubtitlesUrlsGetter < Test::Unit::TestCase

  def setup
    @subs = SubtitlesUrlsGetter.new
    PAGE  = <<-EOF
     <body>
      <tr>
        <td align="center" class="NewsTitle" colspan="3"> Version LOL , 0.00 MBs</td>
        <td colspan="3">uploaded by <a href="/user/10641">honeybunny</a>  248 days ago    </td>
        <td width="16%"></td>
      </tr>
      <tr>
        <td colspan="4"></td>
        <td colspan="3" class="newsDate"><img src="http://www.addic7ed.com/images/invisible.gif"></td>
      </tr>
      <tr><td width="10%" valign="top" rowspan="2">&nbsp;&nbsp;&nbsp;</td>
          <td width="1%" valign="top" rowspan="2"><img src="http://www.addic7ed.com/images/invisible.gif"></td>
          <td width="21%" class="language">English&nbsp;
          <a href="javascript:saveFavorite(49106,1,0)">
            <img border="0" width="20" height="20" src="http://www.addic7ed.com/images/icons/favorite.png" title="Start following..."></a>    
          </td>
          <td width="19%"><b>Completed    </b>  </td>
          <td colspan="3"><img width="24" height="24" src="/images/download.png"> 
             <a href="/original/49106/0" class="buttonDownload"><strong>Download</strong></a>
          </td>
       </tr>
  <tr>
    <td class="newsDate" colspan="2">
<img width="24" height="24" src="/images/icons/invisible.gif"><img width="24" height="24" src="/images/icons/invisible.gif">0 times edited · 115 Downloads · 209 sequences</td>

    <td colspan="3">
<img border="0" width="24" height="24" src="/images/edit.png"><a href="/list.php?id=49106&amp;fversion=0&amp;lang=1">view &amp; edit</a>    &nbsp; 
    </td>
  </tr>
     </body>
    EOF
  end
  
  def test_must_return_an_hash_formatted_with_version_language_and_urls
    assert_equal(
                 { "fqm" => { "english" => '/original/1122/0',
                              "french"  => '/original/21/3' },
                   "lol" => { "english" => '/original/1223/0' }
                 }, @subs.run)
  end

  
end
