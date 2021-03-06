defmodule ShopTest.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias ShopTest.Repo

  alias ShopTest.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(params \\ %{}) do
    from(
      p in Product,
      order_by: ^filter_order_by(params["order_by"])
    )
    |> Repo.all()
  end

  # defp filter_order_by("name_desc"), do: [desc: dynamic([p], p.name)]
  # defp filter_order_by("name_asc"), do: [asc: dynamic([p], p.name)]
  # defp filter_order_by("price_desc"), do: [desc: dynamic([p], p.price)]
  # defp filter_order_by("price_asc"), do: [asc: dynamic([p], p.price)]
  defp filter_order_by("name_desc"), do: [desc: :name]
  defp filter_order_by("name_asc"), do: [asc: :name]
  defp filter_order_by("price_desc"), do: [desc: :price]
  defp filter_order_by("price_asc"), do: [asc: :price]
  defp filter_order_by(_), do: []

  @doc """
  Returns the list of products matching fuzzy search.

  ## Examples

      iex> search_products()
      [%Product{}, ...]

  """
  def search_products(search_phrase) do
    start_character = String.slice(search_phrase, 0..1)

    from(
      p in Product,
      where: ilike(p.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0",  p.name, ^search_phrase),
      order_by: fragment("LEVENSHTEIN(?, ?)", p.name, ^search_phrase)
    )
    |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  def get_product_by_slug(slug), do: Repo.get_by(Product, slug: slug)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
