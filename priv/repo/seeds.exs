# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ShopTest.Repo.insert!(%ShopTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ShopTest.Products

Enum.each(1..30, fn _ ->
  Products.create_product(%{
    name: Faker.Beer.name,
    description: "#{Faker.Beer.style} - #{Faker.Beer.brand}",
    price: (Faker.random_between(200, 1000) / 100.0)
  })
end)
