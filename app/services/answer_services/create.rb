# frozen_string_literal: true

module Services
  module AnswerServices
    class Create
      def initialize(params:, question_id:, user:, version: 1, identification: unique_identification, status: 0)
        @name = params['name']
        @question_id = question_id
        @user = user
        @version = version
        @identification = identification
        @status = status
      end

      def call
        return nil if question_id.blank? || user.blank?

        create_answer
      end

      private

      attr_reader :params, :name, :question_id, :version, :user, :identification, :status

      def create_answer
        ::Answer.new.tap do |a|
          a.name = name
          a.version = version
          a.user_id = user.id
          a.status = status
          a.identification = identification
          a.question_id = question_id
          a.save
        end
      end

      #todo: fix performance implemetation here
      def unique_identification
        result = SecureRandom.uuid
        Answer.find_by(identification: result).blank? ? result : unique_identification
      end
    end
  end
end
