class CallController < ApplicationController

  def index
    @me = current_user
    @friends = User.where('id <> ?', @me.id).order(:name => :asc)
  end

  # whose presence we are interested in
  def friends
    @me = current_user
    @friends = User.where('id <> ?', @me.id).order(:name => :asc)

    # see views/call/friends.json.jbuilder for field selection
    render :format => :json
  end

end
