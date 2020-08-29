defmodule ShopTest.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :state, :string
      add :customer_id, references(:customers, on_delete: :delete_all)

      timestamps()
    end

    create index(:orders, [:customer_id])
  end
end
