defmodule Blog.Repo.Migrations.MakeAdm do
  use Ecto.Migration

  def change do
    #Blog.Repo.update_all("users", set: [type: 1])
    
    %Blog.User{id: 1}
     |> Ecto.Changeset.change(type: 9)
     |> Blog.Repo.update
    
  end
  
end
