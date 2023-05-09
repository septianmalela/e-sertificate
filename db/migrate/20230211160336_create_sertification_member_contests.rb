class CreateSertificationMemberContests < ActiveRecord::Migration[6.1]
  def change
    create_table :sertification_member_contests do |t|
      t.references :school_champion
      t.string     :name
      t.string     :list_contest
      t.string     :position
      t.string     :number_member_contest
      t.string     :url_file

      t.timestamps
    end
  end
end
