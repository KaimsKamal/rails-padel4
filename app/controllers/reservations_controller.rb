class ReservationsController < ApplicationController
  def index
    @reservations = current_user.reservations.upcoming.includes(:court)
  end

  def weekly
    @week_start = parse_week_start(params[:week_start])
    @week_end = @week_start + 6.days

    # Réservations de la semaine, hors annulées
    @reservations = Reservation
      .includes(:court)
      .where(reservation_date: @week_start..@week_end)
      .where.not(status: "annulee")
      .order(:reservation_date, :start_time)

    @courts = Court.all.order(:name)

    # Heures d'ouverture : de 8h à 22h
    @hours = (8..21).to_a

    # Jours de la semaine affichée
    @days = (0..6).map { |i| @week_start + i.days }
  end

  def new
    @reservation = Reservation.new
    @reservation.court_id = params[:court_id] if params[:court_id]
    @courts = Court.available.order(:name)
  end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    @reservation.status = "en_attente"

    if @reservation.save
      redirect_to @reservation, notice: "Réservation créée avec succès."
    else
      @courts = Court.available.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    @reservation.update(status: "annulee")
    redirect_to reservations_path, notice: "Réservation annulée avec succès."
  end

  private

  def reservation_params
    params.require(:reservation).permit(:court_id, :reservation_date, :start_time, :end_time,
                                        :customer_name, :customer_email, :customer_phone)
  end

  # Une date invalide dans l'URL ne doit pas provoquer une erreur 500
  def parse_week_start(value)
    Date.iso8601(value.to_s)
  rescue ArgumentError
    Date.today.beginning_of_week
  end
end
