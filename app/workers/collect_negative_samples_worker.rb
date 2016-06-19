class CollectNegativeSamplesWorker
  include Sidekiq::Worker

  def perform(source_image_id, num_samples)
    img = SourceImage.find(source_image_id)
    NegativeSamplesCollector.collect_negative(img)
  end

end
