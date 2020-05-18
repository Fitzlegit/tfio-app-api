#checks the user authrization checking if the token has been appended
# to a request that is valid
class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  #
  def user
    # returns nil if user isn't found or false
    @user ||= User.find(decode_auth_token[:user_id]) if decoded_auth_token
    # returns implicitly a user object or throws error
    @user || errors.add(:tokens, 'invalid token') && nil
  end

  # decodes the token received from http_auth_header
  def decoded_auth_token
    @decode_auth_token ||= JsonWebToken.decode(http_auth_header)
  end


  # extracts token from authorization header in initialization
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end
