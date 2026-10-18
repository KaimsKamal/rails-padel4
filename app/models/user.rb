class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :players, dependent: :destroy

  # Méthode pour obtenir les initiales de l'utilisateur
  def initials
    if name.present?
      name.split.map(&:first).join.upcase[0..1]
    else
      email[0..1].upcase
    end
  end

  # Méthode pour obtenir l'avatar ou un emoji par défaut
  def avatar_or_default
    avatar.presence || "👤"
  end

  # Méthode pour obtenir le nom d'affichage
  def display_name
    name.presence || email.split("@").first
  end
end
