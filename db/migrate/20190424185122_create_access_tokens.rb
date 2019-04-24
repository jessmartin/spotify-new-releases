class CreateAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :access_tokens do |t|
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_in
      t.string :token_type
      t.string :scope

      t.timestamps
    end
  end
end
