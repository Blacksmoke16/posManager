# frozen_string_literal: true
Rails.application.routes.draw do
	 def version_info
			[200,
			 { 'Content-Type': 'application/json' },
			 [{ app_version: APP_VERSION,
					ruby_version: "#{RUBY_ENGINE}-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}",
					rails_version: Rails.version }.to_json]]
	 end

	 match '*any' => 'application#options', :via => [:options]

	 root 'application#index'

	 namespace :api, defaults: { format: :json } do
			namespace :v1 do
				 root to: proc { version_info }
				 resources :sbs, only: [:index]
				 resources :usbs, only: [:update, :create]
			end
	 end
	 # everything else falls down to angular's ui-router
	 get '*path' => 'application#index'
end
