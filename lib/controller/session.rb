require 'json'

class Session
  def initialize(req)
    cookie = req.cookies["_laurails_app"]
    @cookies = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def store_session(res)
    res.set_cookie "_laurails_app", value: @cookies.to_json, path: "/"
  end
end
