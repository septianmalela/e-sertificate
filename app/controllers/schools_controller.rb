class SchoolsController < ApplicationController
  before_action :get_school, only: %i[edit update destroy show]

  def index
    @schools = School.order(created_at: :desc)
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

  def school_params
    params.require(:school).permit(:name_school)
  end

  def get_school
    @school = School.find(params[:id])
  end
end