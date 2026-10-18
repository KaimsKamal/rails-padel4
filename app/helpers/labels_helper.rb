module LabelsHelper
  DAYS_FR = %w[dimanche lundi mardi mercredi jeudi vendredi samedi].freeze
  MONTHS_FR = %w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre].freeze

  STATUS_LABELS = {
    "en_attente" => "En attente",
    "confirmee" => "Confirmée",
    "annulee" => "Annulée",
    "disponible" => "Disponible",
    "maintenance" => "En maintenance"
  }.freeze

  COURT_TYPE_LABELS = {
    "interieur" => "Intérieur",
    "exterieur" => "Extérieur",
    "couvert" => "Couvert"
  }.freeze

  def day_name_fr(date)
    DAYS_FR[date.wday].capitalize
  end

  def date_long_fr(date)
    "#{date.day} #{MONTHS_FR[date.month - 1]} #{date.year}"
  end

  def status_label(status)
    STATUS_LABELS.fetch(status.to_s, status.to_s.humanize)
  end

  def court_type_label(type)
    COURT_TYPE_LABELS.fetch(type.to_s, type.to_s.humanize)
  end
end
