# frozen_string_literal: true

module Services
  module ElectionServices
    class Update
      def initialize(params:, current_election:, user:)
        @params = params
        @election = current_election
        @user = user
        @identification = election.identification
        @version = (election.version + 1)
      end

      def call
        return nil if user.blank?

        update_election
      end

      private

      attr_reader :params, :user, :election, :identification, :version

      def update_election
        ActiveRecord::Base.transaction do
          election.update(status: 1)
          election_create_service
        end
      end

      def election_create_service
        ::Services::ElectionServices::Create.new(params: params, user: user, version: version, identification: identification).call
      end
    end
  end
end
