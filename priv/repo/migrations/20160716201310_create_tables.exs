defmodule Blog.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :string
      add :email, :string
      add :crypted_password, :string
      add :type, :smallint, null: false, default: 1

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])

    create table(:posts) do
      add :title, :string
      add :body, :text
      add :user_id, :integer, references: {:users, :id}

      timestamps()
    end
    
    create table(:comments) do
      add :user_id, :integer, references: {:users, :id}
      add :post_id, :integer, references: {:posts, :id}
      add :content, :text

      timestamps()
    end

  end
end
