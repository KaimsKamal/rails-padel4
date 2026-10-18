class Player < ApplicationRecord
  belongs_to :reservation
  belongs_to :user, optional: true

  validates :position, presence: true, inclusion: { in: 1..4 }
  validates :position, uniqueness: { scope: :reservation_id }
  validates :name, presence: true, if: -> { user.blank? }

  # Méthode pour obtenir le nom du joueur
  def display_name
    user&.display_name || name
  end

  # Méthode pour obtenir l'avatar du joueur
  def avatar
    user&.avatar_or_default || "👤"
  end

  # Méthode pour obtenir les initiales du joueur
  def initials
    if user
      user.initials
    elsif name.present?
      name.split.map(&:first).join.upcase[0..1]
    else
      "??"
    end
  end
end
