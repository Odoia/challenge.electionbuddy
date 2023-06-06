# frozen_string_literal: true

module Services
  module QuestionServices
    class Create
      def initialize(params:, election:, user:, version: 1, identification: unique_identification, status: 0)
        @name = params[:name]
        @election_id = election.id
        @election_identification = election.identification
        @user = user
        @version = version
        @identification = identification
        @status = status
      end

      def call
        return nil if election_id.blank? || user.blank?

        create_question
      end

      private

      attr_reader :name, :election_id, :user, :version, :identification, :status, :election_identification

      def create_question
        ::Question.new.tap do |q|
          q.name = name
          q.election_id = election_id
          q.election_identification = election_identification
          q.user_id = user.id
          q.version = version
          q.status = status
          q.identification = identification
          q.save
        end
      end

      #todo: fix performance implemetation here
      def unique_identification
        result = SecureRandom.uuid
        Question.find_by(identification: result).blank? ? result : unique_identification
      end
    end
  end
end
