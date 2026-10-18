class Reservation < ApplicationRecord
  belongs_to :court
  belongs_to :user, optional: true
  has_many :players, dependent: :destroy

  accepts_nested_attributes_for :players, allow_destroy: true

  validates :reservation_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_phone, presence: true
  validates :status, presence: true, inclusion: { in: %w[en_attente confirmee annulee] }

  validate :end_time_after_start_time
  validate :no_overlapping_reservations
  validate :reservation_in_future, on: :create

  scope :upcoming, -> { where("reservation_date >= ?", Date.today).order(:reservation_date, :start_time) }
  scope :confirmed, -> { where(status: "confirmee") }

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "doit être après l'heure de début")
    end
  end

  def no_overlapping_reservations
    return if court.blank? || reservation_date.blank? || start_time.blank? || end_time.blank?

    overlapping = court.reservations
                       .where(reservation_date: reservation_date)
                       .where.not(id: id)
                       .where.not(status: "annulee")
                       .where("(start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?) OR (start_time >= ? AND end_time <= ?)",
                              end_time, start_time, end_time, end_time, start_time, end_time)

    if overlapping.exists?
      errors.add(:base, "Ce créneau est déjà réservé")
    end
  end

  def reservation_in_future
    return if reservation_date.blank?

    if reservation_date < Date.today
      errors.add(:reservation_date, "doit être dans le futur")
    end
  end
end
