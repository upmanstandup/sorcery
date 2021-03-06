module Sorcery
  module Controller
    module Submodules
      module Oauth
        module Providers
          # This module adds support for OAuth with Twitter.com.
          # When included in the 'config.providers' option, it adds a new option, 'config.twitter'.
          # Via this new option you can configure Twitter specific settings like your app's key and secret.
          #
          #   config.twitter.key = <key>
          #   config.twitter.secret = <secret>
          #   ...
          #
          module Twitter
            def self.included(base)
              base.module_eval do
                class << self
                  attr_reader :twitter                           # access to twitter_client.

                  def merge_twitter_defaults!
                    @defaults.merge!(:@twitter => TwitterClient)
                  end
                end
                merge_twitter_defaults!
                update!
              end
            end

            module TwitterClient
              class << self
                attr_accessor :key,
                              :secret,
                              :callback_url,
                              :site,
                              :user_info_path,
                              :user_info_mapping
                
                include Oauth1
                
                def init
                  @site           = "https://api.twitter.com"
                  @user_info_path = "/1/account/verify_credentials.json"
                  @user_info_mapping = {}
                end
                
                def get_user_hash(access_token)
                  user_hash = {}
                  response = access_token.get(@user_info_path)
                  user_hash[:user_info] = JSON.parse(response.body)
                  user_hash[:uid] = user_hash[:user_info]['id']
                  user_hash
                end
              end  
              init
            end
          end
        end
      end
    end
  end
end
