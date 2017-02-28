require 'json'

class Flash
  def initialize(req, live_cookies = {}, now_cookies = {})
    @req = req
    dead_cookies = @req.cookies["_laurails_flash"]
    @dead_cookies = dead_cookies ? JSON.parse(dead_cookies) : {}
    @live_cookies = live_cookies
    @now_cookies = now_cookies
  end

  def [](key)
    key = key.to_s

    if @live_cookies[key]
      @live_cookies[key]
    elsif @now_cookies[key]
      @now_cookies[key]
    else
      @dead_cookies[key]
    end
  end

  def store_flash(res)
    res.set_cookie("_laurails_flash", @live_cookies.to_json)
  end

  def []=(key, value)
    @live_cookies[key] = value
  end

  def now
    @now_cookies
  end
end
