class CreateMemberContests < ActiveRecord::Migration[6.1]
  def change
    create_table :member_contests do |t|
      t.references :school
      t.string :name
      t.integer :list_contest

      t.timestamps
    end
  end
end
