Spree::Api::V1::UsersController.class_eval do
  before_action :load_address, only: [:update_address, :delete_address]

  def addresses
    @addresses = current_api_user.addresses
  end

  def add_address
    @address = current_api_user.addresses.build(address_params)
    if @address.save
      render json: {}, status: :ok
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_address
    if @address.editable?
      if @address.update_attributes(address_params)
        render json: {}, status: :ok
      else
        render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
      end
    else
      new_address = @address.clone
      new_address.attributes = address_params
      if new_address.save
        @address.update_attribute(:deleted_at, Time.now)
        render json: {}, status: :ok
      else
        render json: { errors: new_address.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def delete_address
    if @address.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def load_address
    @address = Spree::Address.where(id: params[:id], user_id: current_api_user.id, deleted_at: nil).first
  end

  def address_params
    params.permit(
                  :firstname,
                  :lastname,
                  :address1,
                  :address2,
                  :city,
                  :state_id,
                  :zipcode,
                  :country_id,
                  :phone
    )
  end
end
