class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def create
    event = Event.create!(
      data: params,
      source: params[:source])

    EventJob.perform_later(event)

    render json: { status: :ok }
  end
end
