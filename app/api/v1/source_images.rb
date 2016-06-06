class V1::SourceImages < Grape::API
  resource :source_images do

    desc 'unprocessed images'
    resource :unprocessed do
      get do
        present SourceImage.unprocessed.all
      end
      get :first do
        unprocessed = SourceImage.find_some_unprocessed
        if unprocessed.present?
          present unprocessed
        else
          error!({ message: 'no unprocessed images found' }, 404)
        end
      end
    end

    desc 'returns source image'
    params do
      requires :id, type: Integer, desc: 'source image id'
    end
    route_param :id do
      get do
        img = SourceImage.find(params[:id])
        present img
      end

      desc 'returns source image\'s trace'
      get :trace do
        img = SourceImage.find(params[:id])
        { trace_url: img.trace.url }
      end

      get :trace_file do
        img = SourceImage.find(params[:id])

        content_type "application/octet-stream"
        env['api.format'] = :binary
        header['Content-Disposition'] = "attachment; filename=#{img.trace_file_name}"

        File::open(img.trace.path).read
      end

      desc 'get source image symbols'
      get :symbol_samples do
        img = SourceImage.find(params[:id])
        present img.symbol_samples
      end

      desc 'locks image for processing and returns lock id.'
      put :lock do
        img = SourceImage.find(params[:id])
        begin
          img.lock
        rescue Errors::ImageAlreadyLocked
          error!({ message: 'image already locked' }, 401)
        end
        { lock_id: img.lock_id }
      end

      desc 'post symbol samples'
      params do
        requires :samples, type: Array do
          requires :bounds, type: Hash do
            requires :x, type: Integer
            requires :y, type: Integer
            requires :width, type: Integer
            requires :height, type: Integer
          end
          optional :cser_light_features, type: Array[Float]
          optional :cser_heavy_features, type: Array[Float]
          requires :index, type: Integer
          requires :thres, type: Integer
          requires :symbol, type: String
        end
        requires :lock_id, type: String
      end
      post :symbol_samples do
        source_image_id = params[:id]
        img = SourceImage.find(source_image_id)

        new_samples = params[:samples].map do |sample|
          bounds = sample[:bounds]
          new_sample = SymbolSample.new(
            source_image_id: source_image_id,
            threshold: sample[:thres],
            x: bounds[:x],
            y: bounds[:y],
            width: bounds[:width],
            height: bounds[:height],
            char: sample[:symbol]
          );
          if sample.has_key?(:cser_light_features)
            new_sample.cser_light_features = (sample[:cser_light_features]).to_json
          end
          if sample.has_key?(:cser_heavy_features)
            new_sample.cser_heavy_features = (sample[:cser_heavy_features]).to_json
          end
          new_sample
        end

        begin
          ids = img.add_samples_and_unlock(new_samples, params[:lock_id])
          img.update(
            processed: true,
            locked: false,
            locked_at: nil,
            lock_id: nil
          )
          ids
        rescue Errors::LockValidationFailed
          error!({ message: 'lock validation failed' }, 401)
        end
      end

    end # source_images/:id

    desc 'get source images'
    get do
      present SourceImage.all
    end

    desc 'post source image'
    params do
      requires :picture, type: Rack::Multipart::UploadedFile, desc: "source image"
    end
    post do
      picture = ActionDispatch::Http::UploadedFile.new(params[:picture])
      img = SourceImage.create!(picture: picture)
      present img
    end

  end

end
