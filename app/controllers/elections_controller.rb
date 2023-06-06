# frozen_string_literal: true

class ElectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_election, only: %i[show edit update destroy]

  # GET /elections
  # GET /elections.json
  def index
    @elections = Election.where(user_id: current_user.id).where(status: 0)
  end

  # GET /elections/1
  # GET /elections/1.json
  def show; end

  # GET /elections/new
  def new
    @election = Election.new
  end

  # GET /elections/1/edit
  def edit; end

  # POST /elections
  # POST /elections.json
  def create
    @election = election_create_service
    #@election = Election.new(election_params.merge(user: current_user))

    respond_to do |format|
      if @election.errors.blank?
        format.html { redirect_to @election, notice: 'Election was successfully created.' }
        format.json { render :show, status: :created, location: @election }
      else
        format.html { render :new }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elections/1
  # PATCH/PUT /elections/1.json
  def update
    @election = election_update_service
    respond_to do |format|
      if @election.errors.blank?
        format.html { redirect_to @election, notice: 'Election was successfully updated.' }
        format.json { render :show, status: :ok, location: @election }
      else
        format.html { render :edit }
        format.json { render json: @election.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elections/1
  # DELETE /elections/1.json
  def destroy
    election_delete_service
    respond_to do |format|
      format.html { redirect_to elections_url, notice: 'Election was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_election
    @election = Election.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def election_params
    params.require(:election).permit(:name, :start_at, :end_at, :visibility)
  end

  def election_create_service
    params = election_params
    user = current_user

    ::Services::ElectionServices::Create.new(params: params, user: user).call
  end

  def election_update_service
    params = election_params
    election = @election
    user = current_user

    ::Services::ElectionServices::Update.new(params: params, current_election: election, user: user).call
  end

  def election_delete_service
    election = @election
    user = current_user

    ::Services::ElectionServices::Delete.new(current_election: election, user: user).call
  end
end
