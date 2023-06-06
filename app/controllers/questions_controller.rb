# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_election, only: %i[index new create]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.where(election_identification: @election.identification).where(status: 0)
  end

  # GET /questions/1
  # GET /questions/1.json
  def show; end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit; end
  
  # POST /questions
  # POST /questions.json
  def create
    @question = question_create_service
    respond_to do |format|
      if @question.errors.blank?
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      @question = question_update_service
      if @question.errors.blank?
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    election = question_delete_service.election
    respond_to do |format|
      format.html { redirect_to election_questions_url(election), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  def set_election
    @election = Election.find(params[:election_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_params
    params.require(:question).permit(:name)
  end

  def question_create_service
    params = question_params
    election = @election
    user = current_user

    ::Services::QuestionServices::Create.new(params: params, election: election, user: user).call
  end

  def question_update_service
    params = question_params
    question = @question
    user = current_user

    ::Services::QuestionServices::Update.new(params: params, current_question: question, user: user).call
  end

  def question_delete_service
    question = @question
    user = current_user

    ::Services::QuestionServices::Delete.new(current_question: question, user: user).call
  end
end
