# frozen_string_literal: true

module Services
  module ElectionServices
    class Delete
      def initialize(current_election:, user:)
        @election = current_election
        @user = user
        @identification = election.identification
        @version = (election.version + 1)
        @status = 2
      end

      def call
        return nil if user.blank?

        delete_election
      end

      private

      attr_reader :user, :election, :identification, :version, :status

      def delete_election
        ActiveRecord::Base.transaction do
          election.update(status: 1)
          delete_question_service
          election_create_service
        end
      end

      def election_create_service
        params = election.as_json(except: %i[id version user_id status identification created_at updated_at])
        ::Services::ElectionServices::Create.new(params: params, user: user, version: version, identification: identification, status: status).call
      end

      def delete_question_service
        Question.where(election_identification: election.identification).each do |q|
          ::Services::QuestionServices::Delete.new(current_question: q, user: user).call
        end
      end
    end
  end
end
