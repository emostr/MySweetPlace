require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset email is in the user's language" do
    user = User.create!(email_address: "matvey@example.com", password: "password123", locale: "en")
    mail = PasswordsMailer.reset(user)

    assert_equal "Password reset on MySweetPlace", mail.subject
    assert_equal [ "matvey@example.com" ], mail.to
    assert_match %r{/reset-password/}, mail.text_part.body.to_s
  end
end
