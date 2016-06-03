class ComputeTraceWorker
  include Sidekiq::Worker
  def perform(image_id)
    img = SourceImage.find(image_id)

    tmp_name = Dir::Tmpname.create(['trace']) { }

    Rails.logger.info("running command: nprs-trace #{img.picture.path} #{tmp_name}")

    `nprs-trace #{img.picture.path} #{tmp_name}`
    throw 'Failed to create trace' unless $?.success?

    trace_file = File::new(tmp_name)
    img.update(trace: trace_file)
  end
end
