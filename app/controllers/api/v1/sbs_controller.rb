# frozen_string_literal: true
module Api
  module V1
    class SbsController < ApiController
      respond_to :json
      before_action :find_pos, except: [:index]
      before_action :find_user

      def index
        result = []
        Pos.all.each do |pos|
          custom_data = @user.pos_tracker_users.all.find { |obj| obj.posID == pos.itemID }
          result << pos.as_json.merge(
            silos:       pos.silos,
            visible:     (custom_data.nil? ? true : custom_data[:visible]),
            note:        (custom_data.nil? ? '' : custom_data[:note]).split(','),
            hasRecord:   (custom_data.nil? ? false : custom_data[:id]),
            characterID: @user.characterID
          )
        end
        render json: result
      end

      private

      def find_pos
        @pos = Pos.find(params[:id]) if params[:id]
      end

      def find_user
        @user = User.find_by(id: 1)
      end
    end
  end
end
