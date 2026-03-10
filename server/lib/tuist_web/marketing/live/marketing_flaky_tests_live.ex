defmodule TuistWeb.Marketing.MarketingFlakyTestsLive do
  @moduledoc false
  use TuistWeb, :live_view
  use Noora

  def mount(_params, session, socket) do
    socket =
      socket
      |> attach_hook(:assign_current_path, :handle_params, fn _params, url, socket ->
        uri = URI.parse(url)
        current_path = if uri.query, do: "#{uri.path}?#{uri.query}", else: uri.path
        {:cont, assign(socket, current_path: current_path)}
      end)
      |> TuistWeb.Authentication.mount_current_user(session)

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:head_title, dgettext("marketing", "Flaky Tests · Tuist"))
     |> assign(:head_include_blog_rss_and_atom, false)
     |> assign(:head_include_changelog_rss_and_atom, false)
     |> assign(:head_twitter_card, "summary_large_image")
     |> assign(
       :head_image,
       Tuist.Environment.app_url(path: "/marketing/images/og/home.jpg")
     )
     |> assign(
       :head_description,
       dgettext(
         "marketing",
         "Automatically detect flaky tests that fail without code changes and reduce time spent investigating false failures."
       )
     )}
  end
end
