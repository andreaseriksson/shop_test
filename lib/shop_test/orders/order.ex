defmodule ShopTest.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :state, :string, default: "initial_state"
    belongs_to :customer, ShopTest.Orders.Customer

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
