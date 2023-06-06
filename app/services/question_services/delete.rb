# frozen_string_literal: true

module Services
  module QuestionServices
    class Delete
      def initialize(current_question:, user:)
        @question = current_question
        @user = user
        @election = question.election
        @identification = question.identification
        @version = (question.version + 1)
        @status = 2
      end

      def call
        return nil if user.blank?

        delete_question
      end

      private

      attr_reader :question, :user, :election, :identification, :version, :status

      def delete_question
        ActiveRecord::Base.transaction do
          question.update(status: 1)
          delete_answer_service
          question_create_service
        end
      end

      def question_create_service
        params = { name: question.name }

        ::Services::QuestionServices::Create.new(params: params, election: election, user: user, version: version, identification: identification, status: status).call
      end

      def delete_answer_service
        Answer.where(question_identification: question.identification).each do |a|
          ::Services::AnswerServices::Delete.new(current_answer: a, user: user).call
        end
      end
    end
  end
end
