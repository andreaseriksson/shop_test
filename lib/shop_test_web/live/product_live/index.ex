defmodule ShopTestWeb.ProductLive.Index do
  use ShopTestWeb, :live_view

  import Ecto.Changeset
  alias ShopTest.Products

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:products, list_products())
      |> assign(:changeset, search_changeset())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"search" => %{"search_phrase" => search_phrase}}, socket) when search_phrase == "" do
    {:noreply, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    search
    |> search_changeset()
    |> case do
      %{valid?: true, changes: %{search_phrase: search_phrase}} ->
        {:noreply, assign(socket, :products, Products.search_products(search_phrase))}
      _ ->
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  defp list_products do
    Products.list_products()
  end

  @types %{search_phrase: :string}

  defp search_changeset(attrs \\ %{}) do
    cast(
      {%{}, @types},
      attrs,
      [:search_phrase]
    )
    |> validate_required([:search_phrase])
    |> update_change(:search_phrase, &String.trim/1)
    |> validate_length(:search_phrase, min: 2)
    |> validate_format(:search_phrase, ~r/[A-Za-z0-9\ ]/)
  end
end
