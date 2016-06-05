namespace :trace do
  desc 'Recompute trace for all source images'
  task :recompute_all => :environment do
    SourceImage.all.each do |img|
      ComputeTraceWorker.perform_async(img.id)
    end
  end
end
