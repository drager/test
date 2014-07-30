module PathHelper
  def current_fullpath
    URI.parse(current_url).request_uri
  end
end
