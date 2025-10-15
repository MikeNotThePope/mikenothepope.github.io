defmodule Blog.PostLayout do
  use Blog.Component
  use Tableau.Layout, layout: Blog.RootLayout

  def template(assigns) do
    temple do
      article class: "max-w-3xl mx-auto px-4 py-12" do
        header class: "mb-12" do
          h1 class: "text-4xl font-bold text-gray-900 mb-4 leading-tight" do
            @page[:title]
          end

          if date = @page[:date] do
            time class: "text-gray-600 text-sm" do
              Calendar.strftime(date, "%B %d, %Y")
            end
          end
        end

        div class: "prose prose-lg prose-slate max-w-none" do
          render(@inner_content)
        end
      end
    end
  end
end

