class Api < Grape::API
  version 'v1', using: :header, vendor: 'nprs_train'
  format :json
  prefix 'api'

  helpers do
    def warden
      env['warden']
    end

    def authenticated?
      warden.authenticated?
    end
  end

  before do
    error!("401 Unauthorized", 401) unless authenticated?
  end

  mount V1::Ping
  mount V1::SourceImages

end
