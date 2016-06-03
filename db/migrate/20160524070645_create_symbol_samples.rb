class CreateSymbolSamples < ActiveRecord::Migration
  def change
    create_table :symbol_samples do |t|
      t.string :char
      t.json :cser_light_features
      t.json :cser_heavy_features
      t.references :source_image, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
