class AddDiscardedAtToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :discarded_at, :datetime
    add_index :transactions, :discarded_at
  end
end
