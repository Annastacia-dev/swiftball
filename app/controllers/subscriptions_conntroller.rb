class SubscriptionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    subscription = Subscription.new(subscription_params)
    if subscription.save
      render json: { message: 'Subscription created successfully' }, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.permit(:endpoint, keys: [:p256dh, :auth])
  end
end
