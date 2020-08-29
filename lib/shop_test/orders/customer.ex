defmodule ShopTest.Orders.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :address, :string
    field :city, :string
    field :country, :string
    field :latitude, :float
    field :longitude, :float
    field :name, :string
    field :zip, :string

    has_many :orders, ShopTest.Orders.Order

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :address, :zip, :city, :country, :longitude, :latitude])
    |> validate_required([:name, :address, :zip, :city, :country])
    |> cast_assoc(:orders)
  end
end
