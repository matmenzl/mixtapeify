require 'test_helper'

class PlaylistsMailerTest < ActionMailer::TestCase
  test "share" do
    mail = PlaylistsMailer.share
    assert_equal "Share", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
