class Api < Grape::API
  version 'v1', using: :header, vendor: 'nprs_train'
  format :json
  prefix 'api'

  helpers do
    def warden
      env['warden']
    end

    def authenticated?
      return true if warden.authenticated?

      begin
        http_auth = Base64.decode64(env['HTTP_AUTHORIZATION'].split(" ")[1])
        up = http_auth.split(':')
        email, pass = up[0], up[1]
        user = User.find_by_email(email)
        user && user.valid_password?(pass)
      rescue
        return false
      end
    end
  end

  before do
    error!("401 Unauthorized", 401) unless authenticated?
  end

  mount V1::Ping
  mount V1::SourceImages
  mount V1::SymbolSamples

end
