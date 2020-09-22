class CreateEnvelopes < ActiveRecord::Migration[6.0]
  def change
    create_table :envelopes do |t|
      t.string :size
      t.string :color

      t.timestamps
    end
  end
end
