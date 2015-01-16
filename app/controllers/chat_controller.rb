# The chat controller displays a sub-window of the main application.  It
# manages text chats with one other user (UID).
#
# GET /chat/?uid=foo_uid
#
# We are going to have to do an inverse lookup to find the UID.

class ChatController < ApplicationController

  def index
    @me = current_user
    @oid = params[:uid]
    @friends = User.all.select{ |u| u.rtcc_uid == params[:uid] }
    @friend = @friends[0]

    # make a pseudo-friend if none found, just to simplify layout.  It is not persisted
    if not @friend
      @friend = User.new({:name => "no one", :password => "no password"})
    end

    render :layout => "chat_layout"
  end

end
