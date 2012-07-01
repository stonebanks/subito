# -*- coding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'test/unit'
require 'flexmock/test_unit'
require 'subito/subtitles_urls_getter'
require 'fakeweb'
require 'mechanize'

include Subito

class TestSubtitlesUrlsGetter < Test::Unit::TestCase

  def setup
    page= <<-EOF
<body>
  <table class="tabel95">
        <tr>
	<td>&nbsp;</td>
	<td>
	  <table width="100%" border="0" align="center" class="tabel95">
	    <tr>
		<td align="center" class="NewsTitle" colspan="3">
		  Version x264-ASAP, 120.14 MBs</td>
		<td> </td>
		<td colspan="3">
		  uploaded by <a href="/user/1234">foo</a>  255 seconds ago    </td>
		<td width="16%">
		</td>
	      </tr>
	      <tr>
		<td colspan="4"></td>
	      </tr>
	      <tr><td width="10%" valign="top" rowspan="2">
		  <a href="http://addic7ed.com"><img width="100" height="35" border="0" src="/friends/addic7ed.jpg"></a>&nbsp;&nbsp;&nbsp;</td>
		<td width="1%" valign="top" rowspan="2"><img src="http://www.addic7ed.com/images/invisible.gif">
		</td>
		<td width="21%" class="language">
		  English&nbsp;<a href="javascript:saveFavorite(63834,1,1)"><img width="20" height="20" border="0" src="http://www.addic7ed.com/images/icons/favorite.png" title="Start following..."></a>    
		</td>
		<td width="19%"><b>
		    Completed    </b>
		</td>
		<td colspan="3">
		  <img width="24" height="24" src="/images/download.png"> 
		  <a href="/original/1122/1" class="buttonDownload"><strong>Download</strong></a></td>
		<td>
		</td>
	      </tr>
	      <tr>
		<td class="newsDate" colspan="2">
		  <img width="24" height="24" src="http://www.addic7ed.com/images/bullet_go.png" title="Corrected"><img width="24" height="24" src="http://www.addic7ed.com/images/hi.jpg" title="Hearing Impaired">0 times edited · 0 Downloads · 426 sequences</td>

		<td colspan="3">
		  <img width="24" height="24" border="0" src="/images/edit.png"><a href="/list.php?id=63834&amp;fversion=1&amp;lang=1">view &amp; edit</a>    &nbsp; 
		</td>
	      </tr>
	  </table>
	</td>
	<td>&nbsp;</td>
      </tr>
  </table>
  <table class="tabel95">
    <tr>
	<td>&nbsp;</td>
	<td>
	  <table width="100%" border="0" align="center" class="tabel95">
	    <tr>
		<td align="center" class="NewsTitle" colspan="3"><img width="16" height="16" src="/images/folder_page.png"> 
		  Version FQM, 350.00 MBs&nbsp;</td><td>
		</td>
		<td colspan="3">
		  uploaded by <a href="/user/1111">frfr</a>  424 days ago    </td>
		<td width="16%">
		</td>
	      </tr>
	      <tr>
		<td colspan="4"></td>
	      </tr>
	      <tr><td width="10%" valign="top" rowspan="2">
		  &nbsp;&nbsp;&nbsp;</td>
		<td width="1%" valign="top" rowspan="2"><img src="http://www.addic7ed.com/images/invisible.gif">
		</td>
		<td width="21%" class="language">
		  English&nbsp;<a href="javascript:saveFavorite(43274,1,0)"><img width="20" height="20" border="0" src="http://www.addic7ed.com/images/icons/favorite.png" title="Start following..."></a>    
		</td>
		<td width="19%"><b>
		    Completed    </b>
		</td>
		<td colspan="3">
		  <img width="24" height="24" src="/images/download.png"> 
		  <a href="/original/21/3" class="buttonDownload"><strong>Download</strong></a></td>
		<td>
		</td>
	      </tr>
	      <tr>
		<td class="newsDate" colspan="2">
		  <img width="24" height="24" src="http://www.addic7ed.com/images/bullet_go.png" title="Corrected"><img width="24" height="24" src="/images/icons/invisible.gif">0 times edited · 420 Downloads · 624 sequences</td>

		<td colspan="3">
		  <img width="24" height="24" border="0" src="/images/edit.png"><a href="/list.php?id=43274&amp;fversion=0&amp;lang=1">view &amp; edit</a>    &nbsp; 
		</td>
	      </tr>
	      <tr><td width="10%" valign="top" rowspan="2">
		  &nbsp;&nbsp;&nbsp;</td>
		<td width="1%" valign="top" rowspan="2"><img src="http://www.addic7ed.com/images/invisible.gif">
		</td>
		<td width="21%" class="language">
		  Spanish (Spain)&nbsp;<a href="javascript:saveFavorite(43274,5,0)"><img width="20" height="20" border="0" src="http://www.addic7ed.com/images/icons/favorite.png" title="Start following..."></a>    
		</td>
		<td width="19%"><b>
		    Completed    </b>
		</td>
		<td colspan="3">
		  <img width="24" height="24" src="/images/download.png"> 
		  <a href="/updated/5/1234/0" class="buttonDownload"><strong>Download</strong></a></td>
		<td>
		</td>
	      </tr>
	      <tr>
		<td class="newsDate" colspan="2">
		  <img width="24" height="24" src="http://www.addic7ed.com/images/bullet_go.png" title="Corrected"><img width="24" height="24" src="/images/icons/invisible.gif">47 times edited · 264 Downloads · 624 sequences</td>

		<td colspan="3">
		  <img width="24" height="24" border="0" src="/images/edit.png"><a href="/list.php?id=43274&amp;fversion=0&amp;lang=5">view &amp; edit</a>    &nbsp; 
		  edited  422 days ago    </td>
	      </tr>
	      <tr>
		<td colspan="7">&nbsp;</td>
	      </tr>
	  </table>
	</td>
	<td>&nbsp;</td>
      </tr>
  </table>
</body>
    EOF
    FakeWeb.register_uri(:get, "http://www.foo.com", :body => page, :content_type =>"text/html" )
    flexmock(Verbose).new_instances(:instance).should_receive(:msg).with_any_args.and_return(nil)
    @subs = SubtitlesUrlsGetter.new Mechanize.new.get("http://www.foo.com")
  end
  
  def test_must_return_an_hash_formatted_with_version_language_and_urls
    assert_equal(
                 { "x264-asap" => { "english" => ['/original/1122/1']},
                   "fqm" => {
                     "english"  => ['/original/21/3'],
                     "spanish" => ['/updated/5/1234/0'] }
                 }, @subs.run("//table[@class='tabel95' and @width]"))
  end

  
end
