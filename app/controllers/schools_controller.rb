class SchoolsController < ApplicationController
  before_action :get_school, only: %i[edit update destroy show]

  def index
    @schools = School.order(type_pmr: :asc, created_at: :desc)
    @school  = School.new
  end

  def create
    @school = School.new(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to schools_url, notice: "School was successfully created" }
      else
        format.html { redirect_to schools_url, alert: @school.errors.full_messages.to_sentence }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def show
    @member_contests = @school.member_contests.order(created_at: :desc)
    @member_contest  = @school.member_contests.new
    @list_contests   = MemberContest.list_contests.map { |k, v| [k, k] }
  end

  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to schools_url, notice: "School was successfully Updated." }
      else
        format.html { redirect_to schools_url, alert: @school.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @school.destroy
        format.html { redirect_to schools_url, notice: "School was successfully Deleted." }
      else
        format.html { redirect_to schools_url, alert: @school.errors.full_messages.to_sentence }
      end
    end
  end

  def export_sertification_member_contest
    @member_contests = SchoolChampion.first.sertification_member_contests
    template         = "schools/export_sertification_member_contest.pdf.erb"
    margin_pdf       = { top: 0, bottom: 0, left: 0, right: 0 }

    render pdf: "Piagam Penghargaan",
      locals: { member_contests: @member_contests },
      template: template,
   # disposition: 'attachment',
        layout: "layouts/application.pdf",
     page_size: 'A4',
        margin: margin_pdf
  end

  def school_params
    params.require(:school).permit(:name_school)
  end

  def get_school
    @school = School.find(params[:id])
  end
end