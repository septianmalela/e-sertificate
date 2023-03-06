class School < ApplicationRecord
  has_many :member_contests, dependent: :destroy
  has_many :sertification_member_contests

  validates :name_school, uniqueness: true

  enum type_pmr: ['WIRA', 'MADYA']
  enum list_contest: [ "PERTOLONGAN PERTAMA PUTRA", "PERTOLONGAN PERTAMA PUTRI", "REMAJA SEHAT PEDULI SESAMA",
                       "TANDU OFFICIAL", "TANDU PUTRA", "TANDU PUTRI", "HAND WASHING DANCE",
                       "AYO SIAGA BENCANA", "KESEHATAN REMAJA", "DONOR DARAH SUKARELA",
                       "TANDU PUTRA TUTUP MATA", "TANDU PUTRI TUTUP MATA"
                     ]

  class << self
    def import_data_schools
      data_schools = Roo::Spreadsheet.open('lib/data_excel_school/list_peserta_lomba_susulan.xlsx')

      header_school = data_schools.row(1)
      data_schools.each_with_index do |row, idx|
        next if idx == 0

        param_row      = Hash[[header_school, row].transpose]
        next if param_row['name_school'].blank?

        school         = create_school(param_row)
        member_contest = create_member_contest(school, param_row)
      end
    end

    def create_school(param_row)
      school_type_pmrs = School.type_pmrs

      name_school      = param_row['name_school'].split(' ').reject(&:blank?).join(' ')
      school           = School.find_or_initialize_by(name_school: name_school,
                                                      type_pmr: school_type_pmrs[param_row['type_pmr']])
      return school if !school.new_record?

      school.save
      school
    end

    def create_member_contest(school, param_row)
      name_member_contest = param_row['list_contest'].split(' ').reject(&:blank?).join(' ').upcase
      member_contest      = school.member_contests.new(name: name_member_contest)

      member_contest.total_peserta = param_row['total_peserta']
      member_contest.list_contest  = MemberContest.list_contests[param_row['list_contest']]
      member_contest.save
    end

    def generate_member_contest_sertification
      School.where.not(name_school: ['SMPN 2 KATAPANG', 'SMP BINA NEGARA 2', 'SMPN 1 CIKANCUNG']).each do |school|
        school.member_contests.each do |member_contest|
          member_contest.generate_sertification
        end
      end
    end

    def generate_to_pdf
      School.all.each do |school|
        puts ''
        puts school.name_school
        puts ''
        puts ''
        pdf_html = ActionController::Base.new.render_to_string(template: 'schools/export_sertification_member_contest',
                                                               layout: 'application.pdf',
                                                               locals: { member_contests: school.member_contests })
        pdf = WickedPdf.new.pdf_from_string(pdf_html)

        # save_path = Rails.root.join('public', 'uploads', 'E-Sertification', 'PDF-Sertification', "#{school.name_school}.pdf")
        save_path = Rails.root.join('public', 'uploads', 'E-Sertification', 'SEKOLAH SUSULAN', "#{school.name_school}.pdf")
        File.open(save_path, 'wb') do |file|
          file << pdf
        end
      end
    end
  end
end
