defmodule Blog.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :type, :smallint, null: false, default: 1
    end
  end
  
end
