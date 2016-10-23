defmodule Blog.Post do
  use Blog.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string

	has_many :comment, Blog.Comment, on_delete: :delete_all
    belongs_to :user, Blog.User
	
    timestamps()
  end
  
  @required_fields ~w(title body user_id)
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
  
  def count_comments(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :comment),
      select: {p, count(c.id)}
  end
  
  def preload_comments(post_id, limit, offset \\ 0) do
    query = from c in "comments",
            where: c.post_id == ^post_id,
            limit: ^limit, offset: ^offset,
            select: [c.user_id, c.content]
    comments = Blog.Repo.all(query)
    #[[1, "hhhhjjkll;"], [1, "hjh"], [1, "ddff"], [1, "ghh"]]
    case comments do
      [] -> nil
      _ ->
        user_ids = for comment <- comments do
          [user_id | _] = comment
          user_id
        end
        {preload_comments_users(Enum.uniq(user_ids)), comments}
    end
  end
  
  defp preload_comments_users(user_ids) do
    query = from u in "users",
            where: u.id in ^user_ids,
            select: [u.id, u.nickname]
    Blog.Repo.all(query)
  end
  
end
