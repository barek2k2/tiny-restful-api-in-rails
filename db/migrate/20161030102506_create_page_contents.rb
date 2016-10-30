class CreatePageContents < ActiveRecord::Migration[5.0]
  def change
    create_table :page_contents do |t|
      t.integer :page_id
      t.string :content_type
      t.text :content

      t.timestamps
    end
    add_index(:page_contents, :page_id) unless index_exists?(:page_contents, :page_id)
  end
end
