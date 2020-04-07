class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles, id: :uuid do |t|
      t.string :title
      t.string :description
      t.text :content
      t.string :cover
      t.date :public_date
      t.boolean :hidden
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
