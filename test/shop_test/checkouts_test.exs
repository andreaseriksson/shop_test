defmodule ShopTest.CheckoutsTest do
  use ShopTest.DataCase

  alias ShopTest.Checkouts

  describe "checkouts" do
    alias ShopTest.Checkouts.Checkout

    @valid_attrs %{amount: 123, currency: "some currency", email: "some email", name: "some name", payment_intent_id: "some payment_intent_id", payment_method_id: "some payment_method_id", status: "some status"}
    @update_attrs %{amount: 456, currency: "some updated currency", email: "some updated email", name: "some updated name", payment_intent_id: "some updated payment_intent_id", payment_method_id: "some updated payment_method_id", status: "some updated status"}
    @invalid_attrs %{amount: nil, currency: nil, email: nil, name: nil, payment_intent_id: nil, payment_method_id: nil, status: nil}

    def checkout_fixture(attrs \\ %{}) do
      {:ok, checkout} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Checkouts.create_checkout()

      checkout
    end

    test "list_checkouts/0 returns all checkouts" do
      checkout = checkout_fixture()
      assert Checkouts.list_checkouts() == [checkout]
    end

    test "get_checkout!/1 returns the checkout with given id" do
      checkout = checkout_fixture()
      assert Checkouts.get_checkout!(checkout.id) == checkout
    end

    test "create_checkout/1 with valid data creates a checkout" do
      assert {:ok, %Checkout{} = checkout} = Checkouts.create_checkout(@valid_attrs)
      assert checkout.amount == 123
      assert checkout.currency == "some currency"
      assert checkout.email == "some email"
      assert checkout.name == "some name"
      assert checkout.payment_intent_id == "some payment_intent_id"
      assert checkout.payment_method_id == "some payment_method_id"
      assert checkout.status == "some status"
    end

    test "create_checkout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checkouts.create_checkout(@invalid_attrs)
    end

    test "update_checkout/2 with valid data updates the checkout" do
      checkout = checkout_fixture()
      assert {:ok, %Checkout{} = checkout} = Checkouts.update_checkout(checkout, @update_attrs)
      assert checkout.amount == 456
      assert checkout.currency == "some updated currency"
      assert checkout.email == "some updated email"
      assert checkout.name == "some updated name"
      assert checkout.payment_intent_id == "some updated payment_intent_id"
      assert checkout.payment_method_id == "some updated payment_method_id"
      assert checkout.status == "some updated status"
    end

    test "update_checkout/2 with invalid data returns error changeset" do
      checkout = checkout_fixture()
      assert {:error, %Ecto.Changeset{}} = Checkouts.update_checkout(checkout, @invalid_attrs)
      assert checkout == Checkouts.get_checkout!(checkout.id)
    end

    test "delete_checkout/1 deletes the checkout" do
      checkout = checkout_fixture()
      assert {:ok, %Checkout{}} = Checkouts.delete_checkout(checkout)
      assert_raise Ecto.NoResultsError, fn -> Checkouts.get_checkout!(checkout.id) end
    end

    test "change_checkout/1 returns a checkout changeset" do
      checkout = checkout_fixture()
      assert %Ecto.Changeset{} = Checkouts.change_checkout(checkout)
    end
  end
end
