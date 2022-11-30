class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.belongs_to :user, foreign_key: true
      t.belongs_to :question, foreign_key: true
      t.belongs_to :answer, foreign_key: true

      t.timestamps
    end
  end
end
