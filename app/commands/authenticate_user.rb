#Command takes the user's email and password then returns the user, if
# the credentials match

class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    #this is where parameters are taken when the command is called
    @email = email
    @password = password
  end

  def call
    #this is where the result gets returned
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
