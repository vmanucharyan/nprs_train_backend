namespace :source_images do
  desc 'Unlock all images'
  task :unlock_all => :environment do
    SourceImage
      .where(locked: true)
      .update_all(locked: false, locked_at: nil, lock_id: nil)
  end

  desc 'Recompute trace for all source images'
  task :recompute_all_traces => :environment do
    SourceImage.all.each do |img|
      ComputeTraceWorker.perform_async(img.id)
    end
  end
end
