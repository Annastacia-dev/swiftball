class PushNotificationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    subscription = params['subscription']
    payload = params['payload']

    WebPush.payload_send(
      message: payload,
      endpoint: subscription['endpoint'],
      p256dh: subscription['keys']['p256dh'],
      auth: subscription['keys']['auth'],
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
