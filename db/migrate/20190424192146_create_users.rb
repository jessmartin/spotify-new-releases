class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_in
      t.string :token_type
      t.string :scope
      t.string :remember_token

      t.timestamps
    end
  end
end
