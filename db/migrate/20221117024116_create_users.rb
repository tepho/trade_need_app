class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name, :null => false
      t.string :cpf, :null => false, unique: true, length: 11
      t.string :email, :null => false
      t.string :phone
      t.date :birthday
      t.decimal :balance, :null => false
      t.string :password, :null => false
      t.boolean :is_active, default: true
      
      t.timestamps
    end
  end
end
