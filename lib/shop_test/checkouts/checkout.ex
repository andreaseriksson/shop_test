defmodule ShopTest.Checkouts.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkouts" do
    field :amount, :integer
    field :currency, :string
    field :email, :string
    field :name, :string
    field :payment_intent_id, :string
    field :payment_method_id, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:email, :name, :amount, :currency, :payment_intent_id, :payment_method_id, :status])
    |> validate_required([:email, :name])
  end
end
