# Preview all emails at
# http://localhost:3003/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3003/rails/mailers/user_mailer/account_activation
  def account_activation
    person = Person.first
    person.activation_token = Person.new_token
    UserMailer.account_activation(person)
  end

  # Preview this email at
  # http://localhost:3003/rails/mailers/user_mailer/password_reset
  def password_reset
    person = Person.first
    person.activation_token = Person.new_token
    UserMailer.password_reset(person)
  end

end
