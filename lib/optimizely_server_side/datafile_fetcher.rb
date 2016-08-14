# frozen_string_literal: true
module OptimizelyServerSide

  class DatafileFetcher
    # Responsible for fetching the optimizely sdk config from
    # the API source. The API can be optimizely cdn itself or
    # any other source.

    attr_reader :content, :success

    def initialize(content: nil, success: false)
      @content = content
      @success = success
    end

    class << self

      # Fetch the Config from the specified source.
      # Incase of any error or exception we goto the fallback data
      def fetch
        begin
          response = call_optimizely_cdn
          return fallback unless response.is_a?(Net::HTTPSuccess)
          new(content: response.body, success: true)
        rescue Exception => e
          fallback
        end
      end
      alias_method :datafile, :fetch

      # Gets data from Optimizely cdn
      def call_optimizely_cdn
        ActiveSupport::Notifications.instrument "oss.call_optimizely_cdn",this: :data  do
          Net::HTTP.get_response(
            URI(OptimizelyServerSide.configuration.config_endpoint)
          )
        end
      end

      def fallback
        new(
          content: '{"experiments": [],"version": "1","audiences": [],"dimensions": [],"groups": [],"projectId": "5960232316","accountId": "5955320306","events": [],"revision": "30"}',
          success: false
        )

      end
    end

  end
end
