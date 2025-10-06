defmodule Blog.HomePage do
  use Blog.Component

  use Tableau.Page,
    layout: Blog.RootLayout,
    permalink: "/"

  def template(_assigns) do
    temple do
      p do
        "hello, world!"
      end
    end
  end
end
