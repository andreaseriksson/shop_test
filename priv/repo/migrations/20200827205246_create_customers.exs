defmodule ShopTest.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string
      add :address, :string
      add :zip, :string
      add :city, :string
      add :country, :string
      add :longitude, :float
      add :latitude, :float

      timestamps()
    end

  end
end
