# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show edit update destroy]
  before_action :set_question, only: %i[index new create]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.where(question_identification: @question.identification).where(status: 0)
  end

  # GET /answers/1
  # GET /answers/1.json
  def show; end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit; end

  # POST /answers
  # POST /answers.json
  def create
    @answer = answer_create_service 

    respond_to do |format|
      if @answer.errors.blank?
        format.html { redirect_to @answer, notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    @answer = answer_update_service

    respond_to do |format|
      if @answer.errors.blank?
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    question = answer_delete_service.question
    respond_to do |format|
      format.html { redirect_to question_answers_url(question), notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def answer_params
    params.require(:answer).permit(:name)
  end

  def answer_create_service
    params = answer_params
    question = @question
    user = current_user

    ::Services::AnswerServices::Create.new(params: params, question: question, user: user).call
  end

  def answer_update_service
    params = answer_params
    answer = @answer
    user = current_user

    ::Services::AnswerServices::Update.new(params: params, current_answer: answer, user: user).call
  end

  def answer_delete_service
    answer = @answer
    user = current_user

    ::Services::AnswerServices::Delete.new(current_answer: answer, user: user).call
  end
end
