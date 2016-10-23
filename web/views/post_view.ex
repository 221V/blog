defmodule Blog.PostView do
  use Blog.Web, :view
  
  def show_nickname(comment_user_id, preload_user_info) do
    nickname = for user_info <- preload_user_info, hd(user_info) == comment_user_id do
        hd((tl(user_info)))
    end
    hd(nickname)
  end
  
end
