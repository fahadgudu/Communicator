# The CloudRecorder is a software appliance operated by SightCall.  It can archive and transcode
# recordings.  Use of the service requires an enterprise account.

# The token should be set in the environment
# CLOUDRECORDER_TOKEN = "7e59b98c27331b82ef0e8fa9bfe37fcb" # production (rds postgres 9.3.3)

# The cloudrecorder base is usually fixed
CLOUDRECORDER_BASE = "https://recording.sightcall.com/api"

class CloudrecorderController < ApplicationController

  #
  # Post a request to the Cloudrecorder to allocate a slot for a new recording
  #

  def recording
    if CLOUDRECORDER_TOKEN
      begin
        response = RestClient.post("#{CLOUDRECORDER_BASE}/recordings", { :title => params[:title]  }, 'authorization' => "Token token=#{CLOUDRECORDER_TOKEN}")
        jdata = JSON.parse(response.body)
        # puts "J:#{jdata}"
        render :json => {
          :id => jdata["id"],
          :upload_key => jdata["upload_key"]
        }
      rescue => e
        render :json => {
          :error => e.message
        }
      end
    else
      render :json => { :error => "CloudRecorder not configured" }
    end
  end

  #
  # Request the Detail of a Recording by ID.  Format is JSON.
  #

  def detail

    begin
      response = RestClient.get("#{CLOUDRECORDER_BASE}/recordings/#{params[:id]}", 'authorization' => "Token token=#{CLOUDRECORDER_TOKEN}")
      jdata = JSON.parse(response.body)

      # puts "J:#{jdata}"

      # return only those fields necessary ?
      render :json => {
        :id => jdata["id"],
        :title => jdata["title"],
        :status => jdata["status"],
        :webm_duration => jdata["webm_duration"],
        :webm_s3url => jdata["webm_s3url"],
        :mp4_duration => jdata["mp4_duration"],
        :mp4_s3url => jdata["mp4_s3url"],
        :vb_mediaid => jdata["vb_mediaid"],
        :vb_fileurl => jdata["vb_fileurl"]
      }
    rescue => e
      render :json => {
        :error => e.message
      }
    end
  end
    
end
