class SchoolChampion < ApplicationRecord
  has_many :sertification_member_contests, dependent: :destroy

  class << self
    def generate_all_piagam
      self.all.each do |school_champion|
        school_champion.sertification_member_contests.each do |sertification_member_contest|
          sertification_member_contest.generate_sertification
        end
      end
    end

    def generate_to_pdf
      self.all.each do |school|
        sertification_member_contests = school.sertification_member_contests.group_by(&:number_member_contest)
        SertificationMemberContest.render_to_pdf(school, sertification_member_contests)
      end
    end
  end
end
