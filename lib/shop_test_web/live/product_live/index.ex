defmodule ShopTestWeb.ProductLive.Index do
  use ShopTestWeb, :live_view

  import Ecto.Changeset
  alias ShopTest.Products
  alias ShopTest.Products.Product

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:changeset, search_changeset())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:order_and_filter_changeset, order_and_filter_changeset(params))
      |> assign(:products, list_products(params))
      |> assign(:toggle_ids, [])
      |> assign(:price_changeset, price_changeset())
    }
  end

  @impl true
  def handle_event("search", %{"search" => %{"search_phrase" => search_phrase}}, socket) when search_phrase == "" do
    {:noreply, assign(socket, :products, list_products(%{}))}
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

  def handle_event("order_and_filter", %{"order_and_filter" => order_and_filter_params}, socket) do
    order_and_filter_params
    |> order_and_filter_changeset()
    |> case do
      %{valid?: true} = changeset ->
        {
          :noreply,
          socket
          |> push_patch(to: Routes.product_index_path(socket, :index, apply_changes(changeset)))
        }
      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("toggle-all", %{"value" => "on"}, socket) do
    product_ids = socket.assigns.products |> Enum.map(& &1.id)
    {:noreply, assign(socket, :toggle_ids, product_ids)}
  end

  def handle_event("toggle-all", %{}, socket) do
    {:noreply, assign(socket, :toggle_ids, [])}
  end

  def handle_event("toggle", %{"toggle-id" => id}, socket) do
    id = String.to_integer(id)
    toggle_ids = socket.assigns.toggle_ids

    toggle_ids =
      if (id in toggle_ids) do
        Enum.reject(toggle_ids, & &1 == id)
      else
        [id|toggle_ids]
      end

    {:noreply, assign(socket, :toggle_ids, toggle_ids)}
  end

  def handle_event("delete", %{}, socket) do
    toggle_ids = socket.assigns.toggle_ids
    products = Enum.reject(socket.assigns.products, & &1.id in toggle_ids)
    products_to_be_deleted = Enum.filter(socket.assigns.products, & &1.id in toggle_ids)

    Task.async(fn ->
      products_to_be_deleted
      |> Enum.each(& Products.delete_product/1)
    end)

    {
      :noreply,
      socket
      |> assign(:toggle_ids, [])
      |> assign(:products, products)
    }
  end

  def handle_event("bulk-action", %{"product" => params}, socket) do
    {:noreply,  assign(socket, :price_changeset, price_changeset(params))}
  end

  def handle_event("bulk-trigger", _, socket) do
    changeset = socket.assigns.price_changeset
    toggle_ids = socket.assigns.toggle_ids

    products =
      if changeset.valid? do
        socket.assigns.products
        |> Enum.map(fn product ->
          # Check if the product should update
          if product.id in toggle_ids do
            {:ok, product} = Products.update_product(product, changeset.changes)
            product
          else
            product
          end
        end)
      else
        socket.assigns.products
      end

    {
      :noreply,
      socket
      |> assign(:price_changeset, price_changeset())
      |> assign(:products, products)
      |> assign(:toggle_ids, [])
    }
  end

  @impl true
  def handle_info(_, socket), do: {:noreply, socket}

  defp list_products(params) do
    Products.list_products(params)
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

  defp order_and_filter_changeset(attrs) do
    cast(
      {%{}, %{order_by: :string}},
      attrs,
      [:order_by]
    )
  end

  defp price_changeset(attrs \\ %{}) do
    cast(
      {%{}, %{price: :decimal}},
      attrs,
      [:price]
    )
    |> validate_required([:price])
  end
end
