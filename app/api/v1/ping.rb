class V1::Ping < Grape::API
  desc 'returns pong'
  get :ping do
    { ping: params[:pong] || 'pong' }
  end
end
