class CollectNegativeSamplesWorker
  include Sidekiq::Worker

  def perform(source_image_id, num_samples)
    source_image = SourceImage.find(source_image_id)
    trace = source_image.parse_trace
    regions = trace['regions']

    fail 'no regions in trace' unless regions.present?

    positives = source_image.symbol_samples.positive.to_a

    new_samples =
      if regions.size <= num_samples
        regions
      else
        keys = regions.keys.sample(num_samples)
        regions = keys.map { |key| regions[key] }
        regions.select do |r|
          positives.detect { |ps| r['bounds'] == ps['bounds'] }.blank?
        end
      end

    new_samples.each do |r|
      SymbolSample.create!(
        is_negative: true,
        x: r['bounds']['_field0']['x'],
        y: r['bounds']['_field0']['y'],
        width: r['bounds']['_field1']['x'] - r['bounds']['_field0']['x'],
        height: r['bounds']['_field1']['y'] - r['bounds']['_field0']['y'],
        threshold: r['thres'],
        cser_light_features: r['features'].to_json,
        source_image_id: source_image_id
      )
    end
  end
end
