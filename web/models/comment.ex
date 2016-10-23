defmodule Blog.Comment do
  use Blog.Web, :model

  schema "comments" do
    field :content, :string
    belongs_to :user, Blog.User
    belongs_to :post, Blog.Post

    timestamps()
  end

  @required_fields ~w(content user_id post_id)
  @optional_fields ~w()
  
  @doc """
  Creates a changeset based on the `model` and `params`.
  
  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
