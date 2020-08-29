defmodule ShopTest.OrdersTest do
  use ShopTest.DataCase

  alias ShopTest.Orders
  alias ShopTest.Orders.Customer
  alias ShopTest.Orders.Order

  @valid_customer_attrs %{address: "some address", city: "some city", country: "some country", name: "some name", zip: "some zip"}
  @update_customer_attrs %{address: "some updated address", city: "some updated city", country: "some updated country", name: "some updated name", zip: "some updated zip"}
  @invalid_customer_attrs %{address: nil, city: nil, country: nil, name: nil, zip: nil}

  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(@valid_customer_attrs)
      |> Orders.create_customer()

    customer
  end

  def setup_customer(_) do
    customer = customer_fixture()
    {:ok, customer: customer}
  end

  @valid_order_attrs %{}
  @update_order_attrs %{state: "paid"}
  @invalid_order_attrs %{state: nil}

  def order_fixture(customer, attrs \\ %{}) do
    attrs = Enum.into(attrs, @valid_order_attrs)
    {:ok, order} = Orders.create_order(customer, attrs)

    order
  end

  describe "customers" do
    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Orders.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Orders.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Orders.create_customer(@valid_customer_attrs)
      assert customer.address == "some address"
      assert customer.city == "some city"
      assert customer.country == "some country"
      assert customer.name == "some name"
      assert customer.zip == "some zip"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_customer(@invalid_customer_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Orders.update_customer(customer, @update_customer_attrs)
      assert customer.address == "some updated address"
      assert customer.city == "some updated city"
      assert customer.country == "some updated country"
      assert customer.name == "some updated name"
      assert customer.zip == "some updated zip"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_customer(customer, @invalid_customer_attrs)
      assert customer == Orders.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Orders.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Orders.change_customer(customer)
    end
  end

  describe "orders" do
    setup [:setup_customer]

    test "list_orders/0 returns all orders", %{customer: customer} do
      order = order_fixture(customer)
      assert Orders.list_orders(customer) == [order]
    end

    test "get_order!/1 returns the order with given id", %{customer: customer} do
      order = order_fixture(customer)
      assert Orders.get_order!(customer, order.id) == order
    end

    test "create_order/1 with valid data creates a order", %{customer: customer} do
      assert {:ok, %Order{} = order} = Orders.create_order(customer, @valid_order_attrs)
      assert order.state == "initial_state"
    end

    test "create_order/1 with invalid data returns error changeset", %{customer: customer} do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(customer, @invalid_order_attrs)
    end

    test "update_order/2 with valid data updates the order", %{customer: customer} do
      order = order_fixture(customer)
      assert {:ok, %Order{} = order} = Orders.update_order(order, @update_order_attrs)
      assert order.state == "paid"
    end

    test "update_order/2 with invalid data returns error changeset", %{customer: customer} do
      order = order_fixture(customer)
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_order_attrs)
      assert order == Orders.get_order!(customer, order.id)
    end

    test "delete_order/1 deletes the order", %{customer: customer} do
      order = order_fixture(customer)
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(customer, order.id) end
    end

    test "change_order/1 returns a order changeset", %{customer: customer} do
      order = order_fixture(customer)
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
