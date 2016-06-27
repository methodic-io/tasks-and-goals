# encoding: utf-8
# frozen_string_literal: true

# Encapsulates general mailer methods for the Tasks & Goals application.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
