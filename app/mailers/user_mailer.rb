class UserMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def welcome_email(user)
    mail(:to => user.email, :subject => I18n.t('email.welcome.subject')).deliver
  end

  def invitation_mail(user)
    @user = user
    mail(:to => @user.email, :subject => I18n.t('internal_testing.email.subject')).deliver
  end
end
