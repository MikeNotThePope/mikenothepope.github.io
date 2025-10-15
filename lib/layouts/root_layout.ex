defmodule Blog.RootLayout do
  use Blog.Component
  use Tableau.Layout

  def template(assigns) do
    temple do
      "<!DOCTYPE html>"

      html lang: "en" do
        head do
          meta charset: "utf-8"
          meta http_equiv: "X-UA-Compatible", content: "IE=edge"
          meta name: "viewport", content: "width=device-width, initial-scale=1.0"

          link rel: "icon", type: "image/svg+xml", href: "/favicon.svg"

          title do
            [@page[:title], "Blog"]
            |> Enum.filter(& &1)
            |> Enum.intersperse("|")
            |> Enum.join(" ")
          end

          link rel: "stylesheet", href: "/css/site.css"
          script src: "/js/site.js"
        end

        body class: "bg-gray-50 text-gray-900 min-h-screen" do
          header class: "bg-white border-b border-gray-200" do
            nav class: "max-w-4xl mx-auto px-4 py-6 flex justify-between items-center" do
              a href: "/", class: "text-2xl font-bold text-gray-900 hover:text-gray-700" do
                "MikeNotThePope"
              end

              div class: "flex gap-6" do
                a href: "/", class: "text-gray-600 hover:text-gray-900" do
                  "Home"
                end
                a href: "/about", class: "text-gray-600 hover:text-gray-900" do
                  "About"
                end
              end
            end
          end

          main class: "min-h-[calc(100vh-200px)]" do
            render @inner_content
          end

          footer class: "bg-white border-t border-gray-200 mt-16" do
            div class: "max-w-4xl mx-auto px-4 py-8 text-center text-gray-600 text-sm" do
              p do
                "© #{DateTime.utc_now().year} MikeNotThePope. All rights reserved."
              end
            end
          end

          if Mix.env() == :dev do
            c &Tableau.live_reload/1
          end
        end
      end
    end
  end
end

