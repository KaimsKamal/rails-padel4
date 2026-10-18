# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
abort "Seeds réservés au développement" if Rails.env.production?
puts "🧹 Nettoyage de la base de données..."
Player.destroy_all
Reservation.destroy_all
Court.destroy_all
User.destroy_all

puts "👥 Création des utilisateurs..."

users_data = [
  { email: "test@padel.fr", password: "password123", name: "Test User", avatar: "🎾" },
  { email: "jean@padel.fr", password: "password123", name: "Jean Dupont", avatar: "👨" },
  { email: "marie@padel.fr", password: "password123", name: "Marie Martin", avatar: "👩" },
  { email: "pierre@padel.fr", password: "password123", name: "Pierre Dubois", avatar: "👨‍🦱" },
  { email: "sophie@padel.fr", password: "password123", name: "Sophie Bernard", avatar: "👩‍🦰" },
  { email: "luc@padel.fr", password: "password123", name: "Luc Petit", avatar: "👨‍🦲" },
  { email: "julie@padel.fr", password: "password123", name: "Julie Roux", avatar: "👩‍🦳" },
  { email: "paul@padel.fr", password: "password123", name: "Paul Moreau", avatar: "🧔" }
]

users = users_data.map { |data| User.create!(data) }
puts "✅ #{users.count} utilisateurs créés avec succès!"

puts "🎾 Création des courts de padel..."

courts_data = [
  {
    name: "Court Central",
    court_type: "interieur",
    status: "disponible",
    description: "Court principal avec éclairage LED et air climatisé"
  },
  {
    name: "Court Extérieur 1",
    court_type: "exterieur",
    status: "disponible",
    description: "Court extérieur avec vue panoramique"
  },
  {
    name: "Court Extérieur 2",
    court_type: "exterieur",
    status: "disponible",
    description: "Court extérieur avec gazon synthétique premium"
  },
  {
    name: "Court Couvert",
    court_type: "couvert",
    status: "disponible",
    description: "Court couvert avec toiture rétractable"
  },
  {
    name: "Court VIP",
    court_type: "interieur",
    status: "disponible",
    description: "Court premium avec vestiaires privés et écran géant"
  }
]

courts = courts_data.map { |data| Court.create!(data) }
puts "✅ #{courts.count} courts créés avec succès!"

puts "📅 Création de réservations de démonstration..."

reservations_data = [
  {
    court: courts[0],
    user: users[0],
    reservation_date: Date.today + 1,
    start_time: Time.parse("09:00"),
    end_time: Time.parse("10:30"),
    customer_name: "Jean Dupont",
    customer_email: "jean.dupont@example.com",
    customer_phone: "06 12 34 56 78",
    status: "confirmee"
  },
  {
    court: courts[0],
    user: users[1],
    reservation_date: Date.today + 1,
    start_time: Time.parse("14:00"),
    end_time: Time.parse("15:30"),
    customer_name: "Marie Martin",
    customer_email: "marie.martin@example.com",
    customer_phone: "06 23 45 67 89",
    status: "confirmee"
  },
  {
    court: courts[1],
    user: users[2],
    reservation_date: Date.today + 2,
    start_time: Time.parse("10:00"),
    end_time: Time.parse("11:30"),
    customer_name: "Pierre Dubois",
    customer_email: "pierre.dubois@example.com",
    customer_phone: "06 34 56 78 90",
    status: "en_attente"
  },
  {
    court: courts[2],
    user: users[3],
    reservation_date: Date.today + 2,
    start_time: Time.parse("16:00"),
    end_time: Time.parse("17:30"),
    customer_name: "Sophie Bernard",
    customer_email: "sophie.bernard@example.com",
    customer_phone: "06 45 67 89 01",
    status: "confirmee"
  },
  {
    court: courts[3],
    user: users[4],
    reservation_date: Date.today + 3,
    start_time: Time.parse("11:00"),
    end_time: Time.parse("12:30"),
    customer_name: "Luc Petit",
    customer_email: "luc.petit@example.com",
    customer_phone: "06 56 78 90 12",
    status: "confirmee"
  }
]

reservations = reservations_data.map { |data| Reservation.create!(data) }
puts "✅ #{reservations.count} réservations créées avec succès!"

puts "🏃 Création des joueurs pour les réservations..."

# Réservation 1 - Partie complète (4 joueurs)
Player.create!([
  { reservation: reservations[0], user: users[1], position: 1 },
  { reservation: reservations[0], user: users[2], position: 2 },
  { reservation: reservations[0], user: users[3], position: 3 },
  { reservation: reservations[0], user: users[4], position: 4 }
])

# Réservation 2 - Partie avec 3 joueurs
Player.create!([
  { reservation: reservations[1], user: users[2], position: 1 },
  { reservation: reservations[1], user: users[5], position: 2 },
  { reservation: reservations[1], user: users[6], position: 3 }
])

# Réservation 3 - Partie avec 2 joueurs
Player.create!([
  { reservation: reservations[2], user: users[3], position: 1 },
  { reservation: reservations[2], user: users[4], position: 2 }
])

# Réservation 4 - Partie avec 2 joueurs + 1 invité
Player.create!([
  { reservation: reservations[3], user: users[5], position: 1 },
  { reservation: reservations[3], user: users[6], position: 2 },
  { reservation: reservations[3], user: nil, name: "Invité Marc", position: 3 }
])

# Réservation 5 - Partie avec 4 joueurs
Player.create!([
  { reservation: reservations[4], user: users[1], position: 1 },
  { reservation: reservations[4], user: users[2], position: 2 },
  { reservation: reservations[4], user: users[5], position: 3 },
  { reservation: reservations[4], user: users[7], position: 4 }
])

puts "✅ #{Player.count} joueurs créés avec succès!"

puts "\n🎉 Base de données initialisée avec succès!"
puts "📊 Résumé:"
puts "   - Utilisateurs: #{User.count}"
puts "   - Courts: #{Court.count}"
puts "   - Réservations: #{Reservation.count}"
puts "   - Réservations confirmées: #{Reservation.confirmed.count}"
puts "   - Réservations en attente: #{Reservation.where(status: 'en_attente').count}"
puts "   - Joueurs: #{Player.count}"
puts "\n🔑 Compte de test:"
puts "   Email: test@padel.fr"
puts "   Password: password123"
