class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = User.first || User.new(email: 'test@example.com', confirmation_token: 'faketoken')
    Devise::Mailer.confirmation_instructions(user, user.confirmation_token)
  end

  def reset_password_instructions
    user = User.first || User.new(email: 'test@example.com', reset_password_token: 'faketoken')
    Devise::Mailer.reset_password_instructions(user, user.reset_password_token)
  end

  def unlock_instructions
    user = User.first || User.new(email: 'test@example.com', unlock_token: 'faketoken')
    Devise::Mailer.unlock_instructions(user, user.unlock_token)
  end

  def email_changed
    user = User.first || User.new(email: 'test@example.com')
    Devise::Mailer.email_changed(user)
  end

  def password_change
    user = User.first || User.new(email: 'test@example.com')
    Devise::Mailer.password_change(user)
  end
end
