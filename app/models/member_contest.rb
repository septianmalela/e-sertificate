class MemberContest < ApplicationRecord
  belongs_to :school

  enum list_contest: [ "PERTOLONGAN PERTAMA PUTRA", "PERTOLONGAN PERTAMA PUTRI", "REMAJA SEHAT PEDULI SESAMA",
                       "TANDU DARURAT OFFICIAL", "TANDU DARURAT PUTRA", "TANDU DARURAT PUTRI",
                       "HAND WASHING DANCE", "AYO SIAGA BENCANA", "KESEHATAN REMAJA", "DONOR DARAH SUKARELA",
                       "TANDU DARURAT PUTRA TUTUP MATA", "TANDU DARURAT PUTRI TUTUP MATA"
                     ]

  def generate_sertification
    last_file           = self.url_sertification
    file_sertification  = Rails.root.join("app/assets/images/sertifikat_peserta.png")
    current_folder      = get_current_folder_file
    file_name_png       = "#{get_file_name}.png"
    current_folder      = current_folder.join(file_name_png)
    name_list_contest   = "Peserta #{self.list_contest} #{school.type_pmr}"&.upcase

    canvas = Magick::Image.from_blob(File.new(file_sertification).read).first

    magick_draw = Magick::Draw.new
    # magick_draw.font = "#{Rails.root}/app/assets/fonts/times_new_roman_bold.ttf"
    magick_draw.pointsize = 46
    magick_draw.gravity = Magick::CenterGravity
    magick_draw.annotate(canvas, 0,0,0,-480, 'Peserta')
    magick_draw.annotate(canvas, 0,0,0,-340, name_list_contest)

    canvas.write(current_folder)

    self.url_sertification = "uploads/E-Sertification/SEKOLAH SUSULAN/#{school.name_school}/#{file_name_png}"
    if self.save
      File.delete("public/#{last_file}") rescue nil if last_file.present?
    end
  end

  def get_file_name
    "#{name.strip} - #{SecureRandom.hex(8)}"
  end

  def get_current_folder_file
    folder_akper = Rails.root.join('public', 'uploads', 'E-Sertification', 'SEKOLAH SUSULAN')
    name_folder = folder_akper.join(school.name_school)

    Dir.mkdir(folder_akper) unless Dir.exists?(folder_akper)
    Dir.mkdir(name_folder) unless Dir.exists?(name_folder)
    name_folder
  end

  def name_piagam
    "Terbaik Ke - #{self.position} #{self.type_pmr} #{self.list_contest}"
  end
end
