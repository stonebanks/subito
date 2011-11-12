require 'exception_raiser'
require 'uri'


class DownloadManager

  USER_AGENT = "Mozilla/5.0 (X11; Linux i686; rv:2.0b10)"

  attr_reader :uri

  def initialize(uri_str)
    @uri = URI(uri_str)
  end

  def download(output_name)
  end

  def is_srt?(http_req_response)
  end
end
