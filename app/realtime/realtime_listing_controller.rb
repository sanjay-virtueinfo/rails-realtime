class RealtimeListingController < FayeRails::Controller
  channel '/listing' do
    subscribe do
      Rails.logger.debug "Received on #{channel}: #{inspect}"
      message['message']
    end
  end      
end