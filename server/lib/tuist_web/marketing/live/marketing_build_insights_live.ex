defmodule TuistWeb.Marketing.MarketingBuildInsightsLive do
  use TuistWeb.Marketing.FeaturePage,
    title: "Build Insights · Tuist",
    og_image: "/marketing/images/og/build-insights.jpg",
    description:
      "Monitor build performance across local and CI environments to catch slowdowns before they become bottlenecks."

  alias Tuist.Marketing.Stats

  def mount(params, session, socket) do
    if connected?(socket), do: Stats.subscribe()
    stats = Stats.get_stats()

    {:ok, socket} = super(params, session, socket)
    {:ok, assign(socket, :total_builds, stats.total_builds)}
  end

  def handle_info({:marketing_stats_updated, stats}, socket) do
    {:noreply, assign(socket, :total_builds, stats.total_builds)}
  end
end
