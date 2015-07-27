module UrlHelper
  def self.app_url(condition_name)
    url = "#{condition_name}.#{domain(condition_name)}"
    if env = environment
      url.prepend("#{env}.")
    end
    if port
      url = "#{url}:#{port}"
    end
    "#{protocol}://#{url}"
  end

  def self.protocol
    ENV['URL_PROTOCOL']
  end

  def self.environment
    ENV['URL_ENVIRONMENT']
  end

  def self.domain(condition_name)
    if condition_name == 'mahp'
      ENV['URL_MAHP_DOMAIN']
    else
      ENV['URL_ABRIIZ_DOMAIN']
    end
  end

  def self.port
    ENV['URL_PORT']
  end
end
