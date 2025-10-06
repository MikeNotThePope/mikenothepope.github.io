defmodule Blog.PostLayout do
  use Blog.Component
  use Tableau.Layout, layout: Blog.RootLayout

  def template(assigns) do
    temple do
      render(@inner_content)
    end
  end
end

