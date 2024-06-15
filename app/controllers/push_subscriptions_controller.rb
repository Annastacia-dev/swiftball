class PushSubscriptionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    subscription_params = params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
    subscription = Subscription.find_or_initialize_by(endpoint: subscription_params[:endpoint])
    subscription.keys = subscription_params[:keys]

    if subscription.save
      render json: { message: 'Subscription created successfully' }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
  end
end