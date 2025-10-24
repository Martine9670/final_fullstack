class AddParentToComments < ActiveRecord::Migration[8.0]
  def change
    # On ajoute la colonne manuellement pour éviter les contraintes NOT NULL
    add_column :comments, :parent_id, :integer, null: true

    # On ajoute l’index et la contrainte étrangère à la main
    add_foreign_key :comments, :comments, column: :parent_id
    add_index :comments, :parent_id
  end
end

