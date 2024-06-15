class PushSubscriptionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    push_subscription = PushSubscription.find_or_initialize_by(endpoint: push_subscription_params[:endpoint])
    push_subscription.keys = push_subscription_params[:keys]
    push_subscription.user = current_user

    if push_subscription.save
      render json: { message: 'Push Subscription created successfully' }, status: :created
    else
      render json: { errors: push_subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, keys: [:p256dh, :auth])
  end
end