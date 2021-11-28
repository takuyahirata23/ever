defmodule EverWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation

  alias EverWeb.Resolvers.Users, as: UserResolvers

  @desc "User"
  object :user do
    field :id, :id
    field :name, :string
  end

  object :user_queries do
    @desc "Get users"
    field :users, list_of(:user) do
      resolve(&UserResolvers.read_users/3)
    end
  end
end
