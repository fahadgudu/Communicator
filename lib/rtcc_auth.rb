#
# RTCC Auth Client for Ruby
#
# Prior to using this module, unpack the "client.p12" into its two components as follows:
# 
# openssl pkcs12 -in client.p12 -nocerts -out privateKey.pem
# openssl pkcs12 -in client.p12 -clcerts -nokeys -out publicCert.pem
#
# Tom Sheffler
# Jul 2014
#

require 'net/https'
require 'uri'
require 'openssl'
require 'json'
require 'logger'

Logger = Logger.new(STDOUT)

class RTCCAuth

  def initialize(auth_url, ca_file, public_cert, private_key, cert_password, client_id, client_secret)
    @auth_url = auth_url
    @ca_file = ca_file
    @public_cert = public_cert
    @private_key = private_key
    @cert_password = cert_password
    @client_id = client_id
    @client_secret = client_secret
  end

  def auth(uid, domain, profile)
    Logger.info "RTCCAuth#auth #{uid}"

    url = "#{@auth_url}?client_id=#{@client_id}&client_secret=#{@client_secret}"
    uri = URI.parse(url)

    params = {
      "uid" => uid,
      "identifier_client" => domain,
      "id_profile" => profile
    }

    # Create a new Request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Never enable this debugging statement in production, but it is helpful for debug
    # http.set_debug_output $stderr

    # Add the CA certs
    store = OpenSSL::X509::Store.new
    store.add_cert(OpenSSL::X509::Certificate.new(File.read(@ca_file)))
    http.cert_store = store

    # Add the client cert
    http.key = OpenSSL::PKey::RSA.new(File.read(@private_key), @cert_password)
    http.cert = OpenSSL::X509::Certificate.new(File.read(@public_cert))

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)

    response = http.request(request)

    # Logger.debug "RTCCAuth#auth:resp #{response.inspect}"
      
    # Upon success, this returns an object like:
    #  {"token"=>"7d7744de4dfa349aaa4d4706c6038fc6890cb2da"}
    # Upon failure, this returns an object like:
    #  {"error"=>552, "error_description"=>"[MULTITENANT] This domain is disabled"}

    # Logger.debug "RTCCAuth#body_str #{req.body_str.inspect}"

    begin
      obj = JSON.parse(response.body)
    rescue Exception => e
      Logger.debug "NonJSON Response:::#{response.body}:::"
      obj = { "error" => 500, "error_description" => "Unparsable JSON" }
    end

    # Logger.debug "RTCCAuth#auth:obj #{obj.inspect}"
    return obj

  end

end
