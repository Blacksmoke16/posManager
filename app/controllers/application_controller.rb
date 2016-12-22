# frozen_string_literal: true
class ApplicationController < ActionController::Base
	 # Prevent CSRF attacks by raising an exception.
	 # For APIs, you may want to use :null_session instead.
	 protect_from_forgery with: :exception

	 def index; end

	 def add_allow_credentials_headers
			response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
			response.headers['Access-Control-Allow-Credentials'] = 'true'
	 end

	 def options
			head status: 200, 'Access-Control-Allow-Headers': 'accept, X-CSRF-Token, authorization, content-type'
	 end
end
