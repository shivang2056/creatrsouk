class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def create
    event = Event.create!(event_params)

    handle_event_processing(event)

    render json: { status: :ok }
  end

  private

  def event_params
    params.permit(:source).merge(data: params.to_unsafe_h)
  end

  def handle_event_processing(event)
    EventJob.perform_later(event)
  end
end
