# frozen_string_literal: true

class AuditController < ApplicationController
  before_action :authenticate_user!

  # GET /audit
  # GET /audit.json
  # todo: resolve this query only in one query
  def index
    @elections = Election.joins(questions: [:answers]).distinct.order(created_at: :desc)
  end
end
