class CreateKeywords < ActiveRecord::Migration[5.0]
  def change
    create_table :keywords do |t|
      t.references :paper, foreign_key: true
      t.string :keyword

      t.timestamps
    end
  end
end
