# frozen_string_literal: true

module Services
  module AnswerServices
    class Update
      def initialize(params:, current_answer:, user:)
        @params = params
        @answer = current_answer
        @question_id = answer.question_id
        @user = user
        @identification = answer.identification
        @version = (answer.version + 1)
      end

      def call
        return nil if user.blank?

        update_answer
      end

      private

      attr_reader :params, :question_id, :user, :identification, :version, :answer

      def update_answer
        ActiveRecord::Base.transaction do
          answer.update(status: 1)
          answer_create_service
        end
      end

      def answer_create_service
        ::Services::AnswerServices::Create.new(params: params, question_id: question_id, user: user, version: version, identification: identification).call
      end
    end
  end
end
