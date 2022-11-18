class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :origin_id, :null => false
      t.integer :destiny_id
      t.string :transaction_type_id, :null => false
      t.decimal :amount, :null => false

      t.timestamps
    end
  end
end
