defmodule ShopTestWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `ShopTestWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, ShopTestWeb.ProductLive.FormComponent,
        id: @product.id || :new,
        action: @live_action,
        product: @product,
        return_to: Routes.product_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    title = Keyword.fetch!(opts, :title)
    modal_opts = [id: :modal, return_to: path, title: title, component: component, opts: opts]
    live_component(socket, ShopTestWeb.ModalComponent, modal_opts)
  end
end
