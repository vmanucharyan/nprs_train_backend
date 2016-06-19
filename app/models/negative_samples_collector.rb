class NegativeSamplesCollector
  def self.collect_negative(image)
    trace_regions = image.parse_trace['regions']
    train_data = SymbolSample.collect_positive_dataset
    num_samples = image.symbol_samples.positive.count

    input = {
      trace_regions: trace_regions,
      train_data: train_data,
      num_samples: num_samples
    }

    cmd = Rails.application.config.collect_negative_samples_command
    Open3.popen3(cmd) do |i, o, e, t|
      i.write(input.to_json)
      i.close
      res = JSON.parse(o.read)
      res['samples'].each do |r_idx|
        r = trace_regions[r_idx]
        puts r.inspect
        SymbolSample.create!(
          is_negative: true,
          x: r['bounds']['_field0']['x'],
          y: r['bounds']['_field0']['y'],
          width: r['bounds']['_field1']['x'] - r['bounds']['_field0']['x'],
          height: r['bounds']['_field1']['y'] - r['bounds']['_field0']['y'],
          threshold: r['thres'],
          cser_light_features: r['features'].to_json,
          source_image_id: image.id
        )
      end
    end
  end
end
