defmodule Blog.HomePage do
  use Blog.Component

  use Tableau.Page,
    layout: Blog.RootLayout,
    permalink: "/"

  def template(assigns) do
    temple do
      div class: "max-w-4xl mx-auto px-4 py-8" do
        h1 class: "text-4xl font-bold mb-8" do
          "Recent Posts"
        end

        div class: "space-y-6" do
          for post <- assigns[:posts] || [] do
            article class: "border-b pb-6" do
              h2 class: "text-2xl font-semibold mb-2" do
                a href: post.permalink, class: "hover:underline" do
                  post.title
                end
              end

              p class: "text-gray-600 text-sm mb-2" do
                Calendar.strftime(post.date, "%B %d, %Y")
              end
            end
          end
        end
      end
    end
  end
end
