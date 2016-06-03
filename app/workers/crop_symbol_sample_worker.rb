class CropSymbolSampleWorker
  include Sidekiq::Worker
  def perform(symbol_id)
    symbol = SymbolSample.find(symbol_id)
    source_picture = symbol.source_image.picture
    picture_ext = File.extname(source_picture.path)

    tmp_name = Dir::Tmpname.make_tmpname("cropped_#{symbol.source_image.id}", picture_ext)

    `convert #{symbol.source_image.picture.path} \
      -crop #{symbol.width}x#{symbol.height}+#{symbol.x}+#{symbol.y}! \
      #{tmp_name}`

    throw 'Failed to create cropped symbol sample image' unless $?.success?

    cropped_file = File.open(tmp_name)

    symbol.update(picture: cropped_file)
    Rails.logger.debug(tmp_name);

    `rm #{tmp_name}`
  end
end
