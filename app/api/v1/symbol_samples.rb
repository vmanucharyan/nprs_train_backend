class V1::SymbolSamples < Grape::API
  helpers do
    def parse_fields(klass, fields_param)
      if fields_param.nil?
        klass.columns.map{ |column| column.name.to_sym}
      else
        fields = fields_param.try(:split, ',')
        fields.map(&:to_sym)
      end
    end
  end

  resource :symbol_samples do
    get do
      present SymbolSample.all,
              fields: parse_fields(SymbolSample, params[:fields])
    end

    get :positive do
      present SymbolSample.positive,
              fields: parse_fields(SymbolSample, params[:fields])
    end

    get :negative do
      present SymbolSample.negative,
              fields: parse_fields(SymbolSample, params[:fields])
    end
  end
end
