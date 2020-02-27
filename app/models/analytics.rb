class Analytics
  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user, client_id = nil)
    @user = user
    @client_id = client_id
  end

  def track_user_creation
    identify
    track(
      {
        user_id: user.id,
        event: 'Create User',
      }
    )
  end

  def track_user_sign_in
    identify
    track(
      {
        user_id: user.id,
        event: 'Sign In User'
      }
    )
  end

  private

  def identify
    backend.identify(identify_params)
  end

  attr_reader :user, :client_id

  def identify_params
    {
      user_id: user.id,
      traits: user_traits
    }
  end

  def user_traits
    {
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      city_state: user.city_state,
    }.reject { |key, value| value.blank? }
  end

  def track(options)
    if client_id.present?
      options.merge!(
        context: {
          'Google Analytics' => {
            clientId: client_id
          }
        }
      )
    end
    backend.track(options)
  end
end