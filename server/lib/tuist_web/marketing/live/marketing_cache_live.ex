defmodule TuistWeb.Marketing.MarketingCacheLive do
  use TuistWeb.Marketing.FeaturePage,
    title: "Cache · Tuist",
    og_image: "/marketing/images/og/cache.jpg",
    description:
      "Speeds up builds by reusing compiled binaries, cutting down build times in both local development and CI."

  alias Tuist.Marketing.Stats

  def mount(params, session, socket) do
    if connected?(socket), do: Stats.subscribe()
    stats = Stats.get_stats()

    {:ok, socket} = super(params, session, socket)
    {:ok, assign(socket, :today_artifacts_count, stats.cache_artifacts_today)}
  end

  def handle_info({:marketing_stats_updated, stats}, socket) do
    {:noreply, assign(socket, :today_artifacts_count, stats.cache_artifacts_today)}
  end
end
