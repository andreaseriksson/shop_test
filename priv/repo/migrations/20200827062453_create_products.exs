defmodule ShopTest.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      add :price, :decimal, precision: 8, scale: 2

      timestamps()
    end

    create unique_index(:products, [:slug])
  end
end
