# frozen_string_literal: true

module Services
  module QuestionServices
    class Update
      def initialize(params:, current_question:, user:)
        @params = params
        @question = current_question
        @user = user
        @election = question.election
        @identification = question.identification
        @version = (question.version + 1)
      end

      def call
        return nil if user.blank?

        update_question
      end

      private

      attr_reader :params, :question, :user, :election, :identification, :version

      def update_question
        ActiveRecord::Base.transaction do
          question.update(status: 1)
          question_create_service
        end
      end

      def question_create_service
        ::Services::QuestionServices::Create.new(params: params, election: election, user: user, version: version, identification: identification).call
      end
    end
  end
end
