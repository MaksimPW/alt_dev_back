class ChangeDataToArticles < ActiveRecord::Migration[6.0]
  def change
    rename_column :articles, :hidden, :show
    change_column :articles, :show, :boolean, default: true
  end
end
