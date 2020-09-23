defmodule ShopTest.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :email, :string
      add :name, :string
      add :amount, :integer
      add :currency, :string
      add :payment_intent_id, :string
      add :payment_method_id, :string
      add :status, :string

      timestamps()
    end

  end
end
