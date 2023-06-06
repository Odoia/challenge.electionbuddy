# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :election
  belongs_to :user
  has_many :answers

  enum status: %i[active inactive deleted]
end
