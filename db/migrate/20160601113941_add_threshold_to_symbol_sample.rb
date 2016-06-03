class AddThresholdToSymbolSample < ActiveRecord::Migration
  def change
    add_column :symbol_samples, :threshold, :float
  end
end
