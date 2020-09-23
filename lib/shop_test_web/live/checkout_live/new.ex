defmodule ShopTestWeb.CheckoutLive.New do
  use ShopTestWeb, :live_view

  alias ShopTest.Checkouts
  alias ShopTest.Checkouts.Checkout

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:changeset, Checkouts.change_checkout(%Checkout{}))
      |> assign(:checkout, nil)
      |> assign(:intent, nil)
    }
  end

  @impl true
  def handle_event("submit", %{"checkout" => checkout_params}, socket) do
    case Checkouts.create_checkout(checkout_params) do
      {:ok, checkout} ->
        send(self(), {:create_payment_intent, checkout}) # Run this async

        {:noreply, assign(socket, checkout: checkout, changeset: Checkouts.change_checkout(checkout))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("payment-success", %{"payment_method" => payment_method_id, "status" => status}, socket) do
    checkout = socket.assigns.checkout
    # Update the checkout with the result
    {:ok, checkout} = Checkouts.update_checkout(checkout, %{payment_method_id: payment_method_id, status: status})

    {:noreply, assign(socket, :checkout, checkout)}
  end

  @impl true
  def handle_info({:create_payment_intent, %{email: email, name: name, amount: amount, currency: currency} = checkout}, socket) do
    with {:ok, stripe_customer} <- Stripe.Customer.create(%{email: email, name: name}),
         {:ok, payment_intent} <- Stripe.PaymentIntent.create(%{customer: stripe_customer.id, amount: amount, currency: currency}) do

      # Update the checkout
      Checkouts.update_checkout(checkout, %{payment_intent_id: payment_intent.id})

      {:noreply, assign(socket, :intent, payment_intent)}
    else
      _ ->
        {:noreply, assign(socket, :stripe_error, "There was an error with the stripe")}
    end
  end
end
