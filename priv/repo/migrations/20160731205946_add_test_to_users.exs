defmodule Blog.Repo.Migrations.AddTestToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :test, :bigint, default: 1
    end
  end
  
end
