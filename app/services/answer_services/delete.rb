# frozen_string_literal: true

module Services
  module AnswerServices
    class Delete
      def initialize(current_answer:, user:)
        @answer = current_answer
        @user = user
        @question = answer.question
        @identification = answer.identification
        @version = (answer.version + 1)
        @status = 2
      end

      def call
        return nil if user.blank?

        delete_answer
      end

      private

      attr_reader :answer, :user, :question, :identification, :version, :status

      def delete_answer
        ActiveRecord::Base.transaction do
          answer.update(status: 1)
          answer_create_service
        end
      end

      def answer_create_service
        params = { name: answer.name }

        ::Services::AnswerServices::Create.new(params: params, question: question, user: user, version: version, identification: identification, status: status).call
      end
    end
  end
end
