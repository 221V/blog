defmodule Blog.User do
  use Blog.Web, :model

  schema "users" do
    field :nickname, :string
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :type, :integer
    
    has_many :posts, Blog.Post, on_delete: :delete_all
    has_many :comments, Blog.Comment, on_delete: :delete_all

    timestamps()
    
  end
  
  @required_fields ~w(nickname email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.
  
  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:nickname)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:nickname, ~r/^([\w-+\*])+$/i)
    |> validate_length(:password, min: 8)
  end

end
