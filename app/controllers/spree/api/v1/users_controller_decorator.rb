Spree::Api::V1::UsersController.class_eval do
  def addresses
    @addresses = current_api_user.addresses
  end
end
