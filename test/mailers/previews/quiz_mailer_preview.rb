# Preview all emails at http://localhost:3000/rails/mailers/quiz_mailer
class QuizMailerPreview < ActionMailer::Preview
  def open
    user = User.first
    quiz = Quiz.first
    QuizMailer.with(user_id: user.id, quiz_id: quiz.id).open
  end

  def glitch
    user = User.first
    quiz = Quiz.first
    QuizMailer.with(user_id: user.id, quiz_id: quiz.id).glitch
  end
end
