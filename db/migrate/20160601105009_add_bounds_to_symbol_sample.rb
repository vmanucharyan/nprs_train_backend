class AddBoundsToSymbolSample < ActiveRecord::Migration
  def change
    add_column :symbol_samples, :x, :integer, null: false
    add_column :symbol_samples, :y, :integer, null: false
    add_column :symbol_samples, :width, :integer, null: false
    add_column :symbol_samples, :height, :integer, null: false
  end
end
