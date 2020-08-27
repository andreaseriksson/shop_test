defmodule ShopTestWeb.ProductLive.Show do
  use ShopTestWeb, :live_view

  alias ShopTest.Products

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => slug}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Products.get_product_by_slug(slug))}
  end

  defp page_title(:show), do: "Show Product"
end
