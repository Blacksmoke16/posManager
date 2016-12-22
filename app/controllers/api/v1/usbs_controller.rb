# frozen_string_literal: true
module Api
  module V1
    class UsbsController < ApiController
      respond_to :json
      before_action :find_pos

      def update
        render json: @custom_data if @custom_data.update(base_params)
      end

      def create
        new_user_pos = PosTrackerUser.new(base_params)
        if new_user_pos.save
          render json: new_user_pos, status: :created
        else
          render json: new_user_pos.errors, status: :unprocessable_entity
        end
      end

      private

      def find_pos
        @custom_data = User.find_by(id: 1).pos_tracker_users.find_by(posID: params[:id])
      end

      def base_params
        params.require(:PosTrackerUser).permit(:visible, :note, :characterID, :posID)
      end
    end
  end
end
