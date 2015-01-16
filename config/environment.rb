# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Load env_vars file for development
env_vars = File.join(Rails.root, '/config/env_vars.rb')
load(env_vars) if File.exists?(env_vars)

# Path to the Weemo CA Cert
RTCC_CACERT = ENV['RTCC_CACERT']

# Paths to the extracted key and cert from the client.p12 file
RTCC_CLIENTCERT = ENV['RTCC_CLIENTCERT']
RTCC_CLIENTCERT_KEY = ENV['RTCC_CLIENTCERT_KEY']

# Password
RTCC_CERTPASSWORD = ENV['RTCC_CERTPASSWORD']

# Weemo Auth endpoint, Client ID and Secret
RTCC_AUTH_URL = ENV['RTCC_AUTH_URL']
RTCC_CLIENT_ID = ENV['RTCC_CLIENT_ID']
RTCC_CLIENT_SECRET = ENV['RTCC_CLIENT_SECRET']

# For the front end
RTCC_APP_ID = ENV['RTCC_APP_ID']

# For the cloud recorder
CLOUDRECORDER_TOKEN = ENV['CLOUDRECORDER_TOKEN']
CLOUDRECORDER_UPLOAD_URL = ENV['CLOUDRECORDER_UPLOAD_URL']

# Initialize the Rails application.
Simplelogin::Application.initialize!

