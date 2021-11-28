defmodule EverWeb.Schema do
  use Absinthe.Schema

  alias EverWeb.Schema

  import_types(Schema.UserTypes)

  query do
    import_fields(:user_queries)
  end
end
