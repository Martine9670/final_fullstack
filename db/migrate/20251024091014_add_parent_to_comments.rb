class AddParentToComments < ActiveRecord::Migration[8.0]
  def change
    # add the column manually to avoid NOT NULL constraints.
    add_column :comments, :parent_id, :integer, null: true

    # add the index and the foreign key constraint manually.
    add_foreign_key :comments, :comments, column: :parent_id
    add_index :comments, :parent_id
  end
end

