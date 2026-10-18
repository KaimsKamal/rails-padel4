class Court < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, presence: true
  validates :court_type, presence: true, inclusion: { in: %w[interieur exterieur couvert] }
  validates :status, presence: true, inclusion: { in: %w[disponible maintenance] }

  scope :available, -> { where(status: "disponible") }
end
