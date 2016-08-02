defmodule Blog.Repo.Migrations.DelTestToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :test
    end
  end
  
end
