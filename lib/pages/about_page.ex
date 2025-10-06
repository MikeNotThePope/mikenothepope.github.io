defmodule Blog.AboutPage do
  use Blog.Component

  use Tableau.Page,
    layout: Blog.RootLayout,
    permalink: "/about/"

  def template(_assigns) do
    temple do
      div class: "max-w-4xl mx-auto px-4 py-8" do
        h1 class: "text-4xl font-bold mb-8" do
          "About"
        end

        div class: "prose prose-lg max-w-none" do
          p class: "text-xl mb-6" do
            "Hi, I'm Mike \"Not The\" Pope."
          end

          p class: "mb-4" do
            "I'm 49.5% software engineer, 49.5% recruiter, and 1% nachos (it was a big snack)."
          end

          h2 class: "text-2xl font-bold mt-8 mb-4" do
            "What I Write About"
          end

          p class: "mb-4" do
            "On this blog, I share insights and stories about software development, recruiting, and travel. "

            "Expect a mix of technical deep-dives, lessons learned from building teams, and adventures from around the world."
          end

          h2 class: "text-2xl font-bold mt-8 mb-4" do
            "My Background"
          end

          p class: "mb-4" do
            "I founded Captain Recruiter in 2010 and grew it by word of mouth to $1.2 million in annual revenue "

            "with 15 employees before it was acquired by The Sourcery. I've filled hundreds of technical roles "

            "for companies like Apple, Docker, Heroku, Kiva, and Walmart."
          end

          p class: "mb-4" do
            "From 2019 to 2023, I worked as a digital nomad, living and working remotely in 26 countries across "

            "5 continents. Along the way, I saw a volcanic eruption in Iceland, got lost in a Mexican jungle, "

            "was featured in a Pakistani newspaper, and completed multiple treks through the Himalayas including "

            "Everest Base Camp."
          end

          p class: "mb-4" do
            "Currently, I work as a Senior Software Engineer at Booking.com, where I handle DBA duties for "

            "distributed MySQL clusters managing revenue-generating systems with thousands of servers and 20+ TB of storage."
          end

          h2 class: "text-2xl font-bold mt-8 mb-4" do
            "Connect"
          end

          p class: "flex gap-4" do
            a href: "mailto:mike@mikenotthepope.com",
              class: "text-blue-600 hover:text-blue-800 inline-block",
              "aria-label": "Email" do
              svg class: "w-8 h-8",
                  fill: "currentColor",
                  viewBox: "0 0 24 24",
                  xmlns: "http://www.w3.org/2000/svg",
                  role: "img" do
                path d: "M22 4H2C.9 4 0 4.9 0 6v12c0 1.1.9 2 2 2h20c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zM7.25 14.43l-3.5 2c-.08.05-.17.07-.25.07-.17 0-.34-.1-.43-.25-.14-.24-.06-.55.18-.68l3.5-2c.24-.14.55-.06.68.18.14.24.06.55-.18.68zm4.75.07c-.1 0-.2-.03-.27-.08l-8.5-5.5c-.23-.15-.3-.46-.15-.7.15-.22.46-.3.7-.14L12 13.4l8.23-5.32c.23-.15.54-.08.7.15.14.23.07.54-.16.7l-8.5 5.5c-.08.04-.17.07-.27.07zm8.93 1.75c-.1.16-.26.25-.43.25-.08 0-.17-.02-.25-.07l-3.5-2c-.24-.13-.32-.44-.18-.68s.44-.32.68-.18l3.5 2c.24.13.32.44.18.68z"
              end
            end

            a href: "https://linkedin.com/in/mpope",
              class: "text-blue-600 hover:text-blue-800 inline-block",
              target: "_blank",
              rel: "noopener noreferrer",
              "aria-label": "LinkedIn Profile" do
              svg class: "w-8 h-8",
                  fill: "currentColor",
                  viewBox: "0 0 24 24",
                  xmlns: "http://www.w3.org/2000/svg",
                  role: "img" do
                path d: "M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"
              end
            end
          end
        end
      end
    end
  end
end
