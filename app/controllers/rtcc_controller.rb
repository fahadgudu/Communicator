require 'rtcc_auth'

class RtccController < ApplicationController

  def initialize
    @client = RTCCAuth.new(RTCC_AUTH_URL, RTCC_CACERT, RTCC_CLIENTCERT, RTCC_CLIENTCERT_KEY, RTCC_CERTPASSWORD, RTCC_CLIENT_ID, RTCC_CLIENT_SECRET)
    super
  end

  def callback
    if user_signed_in?
      obj = @client.auth(current_user.rtcc_uid,
                         current_user.rtcc_domain,
                         current_user.rtcc_profile)
    else
      obj = { "error" => 500, "error_description" => "unauthenticated user" }
    end

    # logger.debug "RTCC#callback #{obj}"

    render :json => obj
  end

end
