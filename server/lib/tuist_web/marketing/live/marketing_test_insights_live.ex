defmodule TuistWeb.Marketing.MarketingTestInsightsLive do
  use TuistWeb.Marketing.FeaturePage,
    title: "Test Insights · Tuist",
    og_image: "/marketing/images/og/test-insights.jpg",
    description:
      "Track test performance, catch slow tests early, and debug CI failures without digging through logs."

  alias Tuist.Marketing.Stats

  def mount(params, session, socket) do
    if connected?(socket), do: Stats.subscribe()
    stats = Stats.get_stats()

    {:ok, socket} = super(params, session, socket)
    {:ok, assign(socket, :total_test_case_runs, stats.total_test_case_runs)}
  end

  def handle_info({:marketing_stats_updated, stats}, socket) do
    {:noreply, assign(socket, :total_test_case_runs, stats.total_test_case_runs)}
  end
end
