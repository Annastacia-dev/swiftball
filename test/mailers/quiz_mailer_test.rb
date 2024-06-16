require "test_helper"

class QuizMailerTest < ActionMailer::TestCase
  test "open" do
    mail = QuizMailer.open
    assert_equal "Open", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
