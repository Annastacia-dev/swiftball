class QuizMailer < ApplicationMailer
  helper ApplicationHelper

  def open
    @quiz = Quiz.find(params[:quiz_id])
    @user = User.friendly.find(params[:user_id])
    subject = "[Action Required] #{@quiz.title.titleize} Quiz is  open!"

    mail(
      subject: subject,
      to: @user.email
    )
  end

  def glitch
    @quiz = Quiz.find(params[:quiz_id])
    @user = User.friendly.find(params[:user_id])
    subject = "[Glitch] There's been a glitch - #{@quiz.title.titleize} 😔"

    mail(
      subject: subject,
      to: @user.email
    )
  end

end
