class AddIsNegativeToSymbolSample < ActiveRecord::Migration
  def change
    add_column :symbol_samples, :is_negative, :bool, null: false, default: false
  end
end
