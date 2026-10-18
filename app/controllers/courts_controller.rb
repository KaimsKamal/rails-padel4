class CourtsController < ApplicationController
  def index
    @courts = Court.available.order(:name)
  end

  def show
    @court = Court.find(params[:id])
    @reservations = @court.reservations.upcoming.confirmed
  end
end
