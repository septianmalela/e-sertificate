class CreateSertifications < ActiveRecord::Migration[6.1]
  def change
    create_table :sertifications do |t|
      t.string  :name_file
      t.integer :list_contest
      t.integer :type_pmr
      t.string  :url_link
      t.integer :position

      t.timestamps
    end
  end
end
