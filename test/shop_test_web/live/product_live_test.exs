defmodule ShopTestWeb.ProductLiveTest do
  use ShopTestWeb.ConnCase

  import Phoenix.LiveViewTest

  alias ShopTest.Products

  @create_attrs %{description: "some description", name: "some name", price: "120.50"}

  defp fixture(:product) do
    {:ok, product} = Products.create_product(@create_attrs)
    product
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end

  describe "Index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Listing Products"
      assert html =~ product.description
    end
  end

  describe "Show" do
    setup [:create_product]

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Show Product"
      assert html =~ product.description
    end
  end
end
