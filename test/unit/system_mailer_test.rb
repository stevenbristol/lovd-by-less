require File.dirname(__FILE__) + '/../test_helper'

class AccountMailerTest < ActiveSupport::TestCase

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    @u = users(:user)
  end

  def test_signup
    AccountMailer.deliver_signup(@u)
    assert !ActionMailer::Base.deliveries.empty?

    sent = ActionMailer::Base.deliveries.first
    assert_equal [@u.profile.email], sent.to
    assert_match "Signup info", sent.subject
    assert_match @u.login, sent.body
  end

  def test_forgot_password
    AccountMailer.deliver_forgot_password(@u.profile.email, @u.f, @u.login,'new_pass')
    assert !ActionMailer::Base.deliveries.empty?

    sent = ActionMailer::Base.deliveries.first
    assert_equal [@u.profile.email], sent.to
    assert_match @u.f, sent.body
    assert_match @u.login, sent.body
    assert_match 'new_pass', sent.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/account_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
