defmodule ShopTest.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :decimal
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price])
    |> validate_required([:name, :description, :price])
    |> set_slug(product)
  end

  defp set_slug(changeset, %{slug: "" <> _}), do: changeset
  defp set_slug(changeset, _struct) do
    rand = create_random_part()
    name =
      changeset
      |> get_change(:name, "")
      |> Inflex.parameterize()

    slug = "#{rand}-#{name}"

    case ShopTest.Products.get_product_by_slug(slug) do
      nil -> put_change(changeset, :slug, slug)
      _ -> set_slug(changeset, %{})
    end
  end

  defp create_random_part(length \\ 4) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
