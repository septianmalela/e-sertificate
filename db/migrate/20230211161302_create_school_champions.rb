class CreateSchoolChampions < ActiveRecord::Migration[6.1]
  def change
    create_table :school_champions do |t|
      t.string :name_school
      t.string :type_pmr

      t.timestamps
    end
  end
end
