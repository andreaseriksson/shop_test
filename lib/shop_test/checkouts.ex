defmodule ShopTest.Checkouts do
  @moduledoc """
  The Checkouts context.
  """

  import Ecto.Query, warn: false
  alias ShopTest.Repo

  alias ShopTest.Checkouts.Checkout

  @doc """
  Returns the list of checkouts.

  ## Examples

      iex> list_checkouts()
      [%Checkout{}, ...]

  """
  def list_checkouts do
    Repo.all(Checkout)
  end

  @doc """
  Gets a single checkout.

  Raises `Ecto.NoResultsError` if the Checkout does not exist.

  ## Examples

      iex> get_checkout!(123)
      %Checkout{}

      iex> get_checkout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checkout!(id), do: Repo.get!(Checkout, id)

  @doc """
  Creates a checkout.

  ## Examples

      iex> create_checkout(%{field: value})
      {:ok, %Checkout{}}

      iex> create_checkout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkout(attrs \\ %{}) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checkout.

  ## Examples

      iex> update_checkout(checkout, %{field: new_value})
      {:ok, %Checkout{}}

      iex> update_checkout(checkout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkout(%Checkout{} = checkout, attrs) do
    checkout
    |> Checkout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checkout.

  ## Examples

      iex> delete_checkout(checkout)
      {:ok, %Checkout{}}

      iex> delete_checkout(checkout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checkout(%Checkout{} = checkout) do
    Repo.delete(checkout)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checkout changes.

  ## Examples

      iex> change_checkout(checkout)
      %Ecto.Changeset{data: %Checkout{}}

  """
  def change_checkout(%Checkout{} = checkout, attrs \\ %{}) do
    Checkout.changeset(checkout, attrs)
  end
end
