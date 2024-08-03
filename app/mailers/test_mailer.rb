class TestMailer < ApplicationMailer

  def welcome_email
    mail(to: 'annetotoh@gmail.com', subject: 'Test email')
  end
end