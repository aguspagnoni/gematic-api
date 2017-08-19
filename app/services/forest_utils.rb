class ForestUtils

  class << self

    def toast(msg = '', failed = true)
      { "errors" => [ { "detail" => msg } ] }
    end
  end
end
