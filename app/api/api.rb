class Api < Grape::API
  version 'v1', using: :header, vendor: 'nprs_train'
  format :json
  prefix 'api'

  mount V1::Ping
  mount V1::SourceImages

end
