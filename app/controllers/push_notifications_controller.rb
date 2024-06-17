class PushNotificationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    push_subscription = params['push_subscription']
    payload = params['payload']

    WebPush.payload_send(
      message: payload,
      endpoint: push_subscription['endpoint'],
      p256dh: push_subscription['keys']['p256dh'],
      auth: push_subscription['keys']['auth'],
      vapid: {
        subject: "mailto:sender@example.com",
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      },
      ssl_timeout: 5,
      open_timeout: 5,
      read_timeout: 5
    )

    respond_to do |format|
          format.json { render json: { message: 'Notification sent successfully' }, status: :ok }
    end
  end
end
