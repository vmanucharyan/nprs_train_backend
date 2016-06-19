namespace :symbol_samples do
  desc 'Collect negative samples from all images'
  task :collect_negative => :environment do
    SourceImage.all.each do |source_image|
      positive_count = source_image.symbol_samples.positive.count
      negative_count = source_image.symbol_samples.negative.count
      if negative_count < positive_count
        puts "collecting samples for #{source_image.id}"
        CollectNegativeSamplesWorker.perform_async(
          source_image.id,
          positive_count - negative_count
        )
      end
    end
  end
end
