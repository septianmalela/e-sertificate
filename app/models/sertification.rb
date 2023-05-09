class Sertification < ApplicationRecord
  enum type_pmr: [ 'WIRA', 'MADYA' ]
  enum list_contest: [ "PERTOLONGAN PERTAMA PUTRA", "PERTOLONGAN PERTAMA PUTRI", "REMAJA SEHAT PEDULI SESAMA",
                       "TANDU DARURAT OFFICIAL", "TANDU DARURAT PUTRA TUTUP MATA", "TANDU DARURAT PUTRI TUTUP MATA",
                       "HAND WASHING DANCE", "AYO SIAGA BENCANA", "KESEHATAN REMAJA", "DONOR DARAH SUKARELA",
                       "JUARA UMUM MADYA", 'JUARA UMUM WIRA', 'JUARA UMUM KESELURUHAN',
                       "JUARA UMUM RSPS", "JUARA UMUM PP WIRA", "JUARA UMUM PP MADYA", "JUARA UMUM TANDU MADYA",
                       "JUARA UMUM TANDU WIRA", "RSPS"
                     ]

  def self.create_sertifications
    Sertification.type_pmrs.each do |key, value|
      Sertification.list_contests.each do |kk, vv|
        (1..6).to_a.each do |num|
          name_file = "Terbaik Ke - #{num} #{key} #{kk}"
          Sertification.new(name_file: name_file, list_contest: vv, type_pmr: value, position: num).save
        end
      end
    end
  end

  def self.create_all_jumum
    hash_nama_jumum = { "JUARA UMUM TANDU WIRA" => "SMA BINA NEGARA",
                        "JUARA UMUM TANDU MADYA" => "SMP ANGKASA",
                        "JUARA UMUM PP WIRA" => "SMAN 1 BALEENDAH",
                        "JUARA UMUM PP MADYA" => "SMPN 3 CILEUNYI ",
                        "JUARA UMUM RSPS" => "SMK ASSHIFA"
                      }
    hash_nama_jumum.each do |key, value|
      sertification = Sertification.find_or_initialize_by(name_file: value)
      next if !sertification.new_record?

      name_file = key.split(" ").last.strip
      sertification.list_contest = key
      sertification.type_pmr     = key.eql?('JUARA UMUM RSPS') ? 'MADYA' : name_file
      sertification.save
    end
  end

  def self.create_jumum
    hash_nama_jumum = { "JUARA UMUM MADYA" => "SMPN 3 CILEUNYI",
                        "JUARA UMUM WIRA" => "SMAN 1 BALEENDAH",
                        "JUARA UMUM KESELURUHAN" => "SMAN 1 BALEENDAH"
                      }
    hash_nama_jumum.each do |key, value|
      sertification = Sertification.find_or_initialize_by(name_file: "#{key} -> #{value}")
      next if !sertification.new_record?

      name_file = key.split(" ").last.strip
      sertification.list_contest = key
      sertification.type_pmr     = key.eql?('JUARA UMUM KESELURUHAN') ? 'WIRA' : name_file
      sertification.save
    end
  end

  def self.custom_sertification
    # list_sertification = [
    #                         ['SMAN 1 CIPARAY', 'uploads/E-Sertification/HAND WASHING DANCE/Terbaik Ke - 5 WIRA HAND WASHING DANCE.png', 'WIRA', 'HAND WASHING DANCE'],
    #                         ['SMA PASUNDAN BANJARAN', 'uploads/E-Sertification/HAND WASHING DANCE/Terbaik Ke - 6 WIRA HAND WASHING DANCE.png', 'WIRA', 'HAND WASHING DANCE'],
    #                         ['SMKN 2 BALEENDAH', 'uploads/E-Sertification/DONOR DARAH SUKARELA/Terbaik Ke - 6 WIRA HAND WASHING DANCE.png', 'WIRA', 'DONOR DARAH SUKARELA'],
    #                       ]
    # Sertification.destroy_all
    # list_sertification.each_with_index do |key, idx|
    #   Sertification.create(name_file: key[0], list_contest: key[3], type_pmr: key[2], url_link: key[1])
    # end

    list_sertification = [ ['TANDU DARURAT OFFICIAL', 'Terbaik Ke - 3 TANDU DARURAT OFFICIAL'],
                           ['TANDU DARURAT OFFICIAL', 'Terbaik Ke - 5 TANDU DARURAT OFFICIAL'] ]

    list_sertification.each do |key|
      Sertification.create(name_file: key[1], type_pmr: 'WIRA', list_contest: 'TANDU DARURAT OFFICIAL')
    end
  end

  def self.generate_all_piagam
    self.all.each do |sertification|
      file_sertification  = Rails.root.join("app/assets/images/piagam_penghargaan.png")
      current_folder      = sertification.get_current_folder_file
      file_name_png       = "#{sertification.name_file}.png"
      current_folder      = current_folder.join(file_name_png)

      canvas = Magick::Image.from_blob(File.new(file_sertification).read).first

      magick_draw = Magick::Draw.new
      # magick_draw.font = "#{Rails.root}/app/assets/fonts/times_new_roman_bold.ttf"
      magick_draw.pointsize = 38
      magick_draw.gravity = Magick::CenterGravity
      magick_draw.font_weight = Magick::BoldWeight
      if sertification.name_file.split('WIRA').length >= 2
        split_name = sertification.name_file.split('WIRA').map(&:strip)
        first_name = "#{split_name[0]} WIRA"
        second_name = split_name[1]
      else
        split_name = sertification.name_file.split('MADYA').map(&:strip)
        first_name = "#{split_name[0]} MADYA"
        second_name = split_name[1]
      end

      # split_name = sertification.name_file.split('TANDU DARURAT OFFICIAL').map(&:strip)
      # first_name = "#{split_name[0]}"
      # second_name = "TANDU DARURAT OFFICIAL"
      magick_draw.annotate(canvas, 0,0,0,-650, sertification.name_file.split('->').last.strip)
      magick_draw.annotate(canvas, 0,0,0,-400, sertification.list_contest)
      # magick_draw.annotate(canvas, 0,0,0,-400, sertification.name_file)
      # magick_draw.annotate(canvas, 0,0,0,-380, second_name)
      magick_draw.annotate(canvas, 0,0,0,-300, 'Perlombaan')

      canvas.write(current_folder)

      sertification.url_link = "uploads/E-Sertification/JUMUM/#{sertification.list_contest}/#{file_name_png}"
      sertification.save
    end
  end

  def get_current_folder_file
    folder_akper = Rails.root.join('public', 'uploads', 'E-Sertification', 'JUMUM')
    name_folder = folder_akper.join(list_contest)

    Dir.mkdir(folder_akper) unless Dir.exists?(folder_akper)
    Dir.mkdir(name_folder) unless Dir.exists?(name_folder)
    name_folder
  end

  def self.render_to_pdf
    self.all.each_with_index do |sert, idx|
      self.create_folder_jumum
      margin_pdf = { top: 0, bottom: 0, left: 0, right: 0 }
      pdf_html = ActionController::Base.new.render_to_string(template: 'schools/export_sertification_member_contest.pdf.erb',
                                                             layout: 'layouts/application.pdf',
                                                             locals: { member_contests: [sert] },
                                                             page_size: 'A4', margin: margin_pdf)
      pdf       = WickedPdf.new.pdf_from_string(pdf_html)
      save_path = Rails.root.join('public', 'uploads', "Auxilium D'Uno", "CUSTOM", "JUARA-UMUM-#{idx}.pdf")

      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    end
  end

  def self.create_folder_jumum
    folder_akper = Rails.root.join('public', 'uploads', "Auxilium D'Uno")
    name_folder = folder_akper.join('MADYA')

    Dir.mkdir(folder_akper) unless Dir.exists?(folder_akper)
    Dir.mkdir(name_folder) unless Dir.exists?(name_folder)
    name_folder
  end
end
