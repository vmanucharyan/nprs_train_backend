class V1::Ping < Grape::API
  before do
    authenticate!
  end

  desc 'returns pong'
  get :ping do
    { ping: params[:pong] || 'pong' }
  end
end
