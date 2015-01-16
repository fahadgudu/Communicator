require 'rtcc_auth'

class ApiController < ApplicationController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  skip_before_filter :authorize

  before_filter :api_authorize

  def initialize
    @client = RTCCAuth.new(RTCC_AUTH_URL, RTCC_CACERT, RTCC_CLIENTCERT, RTCC_CLIENTCERT_KEY, RTCC_CERTPASSWORD, RTCC_CLIENT_ID, RTCC_CLIENT_SECRET)
    super
  end

  def token
    if user_signed_in?
      obj = @client.auth(current_user.rtcc_uid,
                         current_user.rtcc_domain,
                         current_user.rtcc_profile)

    else
      obj = { "error" => 500, "error_description" => "unauthenticated user" }
    end

    logger.debug "RTCC#token #{obj}"

    render :json => obj
  end

  def appid
    if user_signed_in?
      obj = { "appid" => RTCC_APP_ID }
    else
      obj = { "error" => 500, "error_description" => "unauthenticated user" }
    end

    render :json => obj
  end

  def me
    if user_signed_in?
      me = current_user
      obj = { "me" => { "name" => me.name, "rtcc_uid" => me.rtcc_uid} }
    else
      obj = { "error" => 500, "error_description" => "unauthenticated user" }
    end

    render :json => obj
  end

  def friends
    @me = current_user
    @friends = User.where('id <> ?', @me.id).order(:name => :asc)

    friends = @friends.map do |f|
      { "name" => f.name, "rtcc_uid" => f.rtcc_uid }
    end

    obj = { "friends" => friends }

    render :json => obj
  end

  def api_authorize
    authenticate_or_request_with_http_basic do |username, password|
      logger.info "BASIC AUTH: #{username} #{password}"
      @current_user = User.authenticate(username, password)
    end
  end

end
