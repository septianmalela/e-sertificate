class SertificationsController < ApplicationController
  def index
    @sertifications = Sertification.order(type_pmr: :asc, list_contest: :asc, position: :asc)
  end

  def export_jumum
    @sertifications = Sertification.where(list_contest: [ "JUARA UMUM MADYA", 'JUARA UMUM WIRA', 'JUARA UMUM KESELURUHAN' ])
    template        = "sertifications/export_sertification.pdf.erb"
    margin_pdf      = { top: 0, bottom: 0, left: 0, right: 0 }

    respond_to do |format|
      format.pdf do
        render pdf: "JUARA UMUM",
              template: template,
           # disposition: 'attachment',
                layout: "layouts/application.pdf",
             page_size: 'A4',
                margin: margin_pdf
      end
    end
  end

  def export_sertification
    @sertifications = Sertification.where(list_contest: params[:list_contest])
                                   .order(type_pmr: :asc, list_contest: :asc, position: :asc)
    template        = "sertifications/export_sertification.pdf.erb"
    margin_pdf      = { top: 0, bottom: 0, left: 0, right: 0 }

    respond_to do |format|
      format.pdf do
        render pdf: "Piagam Penghargaan",
              template: template,
           # disposition: 'attachment',
                layout: "layouts/application.pdf",
             page_size: 'A4',
                margin: margin_pdf
      end
    end
  end
end