# For APIs we want to return error messages with the appropriate status if
# something goes wrong. This helper allows us to keep the controllers clean
# by using "create!" and "save!" methods, which will invoke this handler on
# errors.
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { message: e.message }, status: :unprocessable_entity
    end
  end
end