class SertificationMemberContest < ApplicationRecord
  belongs_to :school_champion

  class << self
    def import_champion_member_contest
      data_schools = Roo::Spreadsheet.open('lib/data_excel_school/data_peserta_madya.xlsx')

      header_school = data_schools.row(1)
      data_schools.each_with_index do |row, idx|
        next if idx == 0

        param_row = Hash[[header_school, row].transpose]
        next if param_row['NAMA SEKOLAH'].blank?

        school         = create_school_champion(param_row)
        member_contest = create_sertification_member_contest(school, param_row)
      end
    end

    def create_school_champion(param_row)
      school = SchoolChampion.find_or_initialize_by(name_school: param_row['NAMA SEKOLAH'].strip)
      return school if !school.new_record?

      school.type_pmr = param_row['TINGKAT']
      school.save
      school
    end

    def create_sertification_member_contest(school, param_row)
      sertification = school.sertification_member_contests.new(name: param_row['NAMA LENGKAP'],
                                                               list_contest: param_row['MATA LOMBA'],
                                                               position: param_row['JUARA'],
                                                               number_member_contest: param_row['NOMOR PESERTA'].strip).save
    end

    def render_to_pdf(school, sertification_member_contests)
      sertification_member_contests.each do |key, value|
        value.first.create_folder_list_contest
        name_file = "#{school.name_school} - Juara #{value.first.position} - #{key}"

        margin_pdf = { top: 0, bottom: 0, left: 0, right: 0 }
        pdf_html = ActionController::Base.new.render_to_string(template: 'schools/export_sertification_member_contest.pdf.erb',
                                                               layout: 'layouts/application.pdf',
                                                               locals: { member_contests: value },
                                                               page_size: 'A4', margin: margin_pdf)
        pdf       = WickedPdf.new.pdf_from_string(pdf_html)
        save_path = Rails.root.join('public', 'uploads', "Auxilium D'Uno", "MADYA", "#{school.name_school}", "#{key}", "#{name_file}.pdf")

        File.open(save_path, 'wb') do |file|
          file << pdf
        end
      end
    end
  end

  def generate_sertification
    file_sertification = Rails.root.join("app/assets/images/blank_image.png")
    current_folder     = get_current_folder_file
    name_file          = "#{self.name} - #{school_champion.name_school} - #{self.number_member_contest}"
    file_name_png      = "#{name_file}.png"
    current_folder     = current_folder.join(file_name_png)

    canvas = Magick::Image.from_blob(File.new(file_sertification).read).first

    magick_draw = Magick::Draw.new
    # magick_draw.font = "#{Rails.root}/app/assets/fonts/times_new_roman_bold.ttf"
    magick_draw.pointsize   = 38
    magick_draw.gravity     = Magick::CenterGravity
    magick_draw.font_weight = Magick::BoldWeight
    magick_draw.annotate(canvas, 0,0,0,-650, self.name)

    canvas.write(current_folder)

    self.url_file = "uploads/Auxilium D'Uno/MADYA/#{school_champion.name_school}/#{file_name_png}"
    self.save
  end

  def get_current_folder_file
    folder_akper = Rails.root.join('public', 'uploads', "Auxilium D'Uno")
    name_folder = folder_akper.join('MADYA', "#{school_champion.name_school}")

    Dir.mkdir(folder_akper) unless Dir.exists?(folder_akper)
    Dir.mkdir(name_folder) unless Dir.exists?(name_folder)
    name_folder
  end

  def create_folder_list_contest
    folder_akper = Rails.root.join('public', 'uploads', "Auxilium D'Uno")
    name_folder  = folder_akper.join('MADYA', "#{school_champion.name_school}", "#{number_member_contest}")

    Dir.mkdir(folder_akper) unless Dir.exists?(folder_akper)
    Dir.mkdir(name_folder) unless Dir.exists?(name_folder)
    name_folder
  end
end
