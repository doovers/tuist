defmodule TuistWeb.Marketing.MarketingSelectiveTestingLive do
  use TuistWeb.Marketing.FeaturePage,
    title: "Selective Testing · Tuist",
    og_image: "/marketing/images/og/selective-testing.jpg",
    description:
      "Run only the tests that matter by detecting changes since your last successful run, cutting down test times in both local development and CI."

  alias Tuist.Marketing.Stats

  def mount(params, session, socket) do
    if connected?(socket), do: Stats.subscribe()
    stats = Stats.get_stats()

    {:ok, socket} = super(params, session, socket)
    {:ok, assign(socket, :total_test_runs, stats.total_test_runs)}
  end

  def handle_info({:marketing_stats_updated, stats}, socket) do
    {:noreply, assign(socket, :total_test_runs, stats.total_test_runs)}
  end
end
