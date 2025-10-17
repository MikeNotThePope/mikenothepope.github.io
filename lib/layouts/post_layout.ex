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

        div class: "mt-12 pt-8 border-t border-gray-200" do
          div class: "bg-blue-50 border border-blue-200 rounded-lg p-6" do
            h3 class: "text-xl font-bold mb-3 text-gray-900" do
              "Enjoyed this post? Subscribe for more."
            end

            p class: "text-gray-700 mb-4 text-sm" do
              "Get new posts delivered to your inbox. Easy to unsubscribe if it's not for you."
            end

            form action: "https://buttondown.com/api/emails/embed-subscribe/MikeNotThePope",
                 method: "post",
                 target: "popupwindow",
                 onsubmit: "window.open('https://buttondown.com/MikeNotThePope', 'popupwindow')",
                 class: "embeddable-buttondown-form" do
              div class: "flex flex-col sm:flex-row gap-2" do
                input type: "email",
                      name: "email",
                      id: "bd-email-post",
                      placeholder: "you@example.com",
                      class: "flex-1 px-4 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500",
                      required: true

                input type: "submit",
                      value: "Subscribe",
                      class: "px-6 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 cursor-pointer transition-colors"
              end
            end
          end
        end
      end
    end
  end
end

