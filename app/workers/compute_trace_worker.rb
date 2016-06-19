class ComputeTraceWorker
  include Sidekiq::Worker
  # sidekiq_options queue: 'low'

  def perform(image_id)
    img = SourceImage.find(image_id)

    tmp_file = Tempfile.new("trace_#{img.id}")
    tmp_name = tmp_file.path

    Rails.logger.info("trace temp file path: #{tmp_name}")
    Rails.logger.info("picture path: #{img.picture.path}")

    cmd = "#{Rails.application.config.nprs_trace_path} #{img.picture.path} #{tmp_name}"
    Rails.logger.info("running command: #{cmd}")

    `#{cmd}`
    throw 'Failed to create trace' unless $?.success?

    img.update(trace: tmp_file)

    tmp_file.unlink
  end
end
