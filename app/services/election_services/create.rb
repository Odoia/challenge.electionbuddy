# frozen_string_literal: true

module Services
  module ElectionServices
    class Create
      def initialize(params:, user:, version: 1, identification: unique_identification, status: 0)
        @params = params
        @name = params['name']
        @visibility = params['visibility']
        @user = user
        @version = version
        @identification = identification
        @status = status
      end

      def call
        return nil if user.blank?

        create_election
      end

      private

      attr_reader :params, :name,  :visibility, :start_at, :end_at, :settings, :version, :user, :identification, :status

      def create_election
        election ||= ::Election.new(params)
        election.tap do |e|
          e.name = name
          e.settings = { visibility: visibility }
          e.version = version
          e.user_id = user.id
          e.status = status
          e.identification = identification
          e.save
        end
      end

      #todo: fix performance implemetation here
      def unique_identification
        result = SecureRandom.uuid
        Election.find_by(identification: result).blank? ? result : unique_identification
      end
    end
  end
end
