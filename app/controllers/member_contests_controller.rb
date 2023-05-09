class MemberContestsController < ApplicationController
  before_action :get_school
  before_action :get_member_contest, only: %i[edit update destroy show]

  def new
    @member_contest = @school.member_contests.new
  end

  def create
    @member_contest = @school.member_contests.create(member_contest_params)
    respond_to do |format|
      if @member_contest.save
        format.html { redirect_to school_path(@school), notice: "Peserta lomba was successfully created" }
      else
        format.html { redirect_to school_path(@school), alert: @member_contest.errors.full_messages.to_sentence }
      end
    end
  end

  def edit
    @list_contests = MemberContest.list_contests.map { |k, v| [k, k] }
    respond_to do |format|
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @member_contest.destroy
        format.html { redirect_to school_path(@school), notice: "Peserta lomba was successfully deleted" }
      else
        format.html { redirect_to school_path(@school), alert: @member_contest.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    respond_to do |format|
      if @member_contest.update(member_contest_params)
        format.html { redirect_to school_path(@school), notice: "Peserta lomba was successfully updated" }
      else
        format.html { redirect_to school_path(@school), alert: @member_contest.errors.full_messages.to_sentence }
      end
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def get_school
    @school = School.find(params[:school_id])
  end

  def get_member_contest
    @member_contest = MemberContest.find(params[:id])
  end

  def member_contest_params
    params.require(:member_contest).permit(:name, :list_contest)
  end
end