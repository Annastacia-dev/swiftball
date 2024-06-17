class QuizMailer < ApplicationMailer
  def open
    @quiz = Quiz.find(params[:quiz_id])
    @user = User.find(params[:user_id])
    subject = "[Action Required] #{@quiz.title.titleize} Quiz is now open!"

    mail(
      subject: subject,
      to: @user.email
    )
  end
end
