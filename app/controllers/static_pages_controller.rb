class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.microposts.page(params[:page])
      .per(Settings.per_page_user)
  end

  def help; end

  def about; end

  def contact; end

  def login; end

  def news; end
end
