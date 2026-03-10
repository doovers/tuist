defmodule TuistWeb.Marketing.MarketingFlakyTestsLive do
  use TuistWeb.Marketing.FeaturePage,
    title: "Flaky Tests · Tuist",
    og_image: "/marketing/images/og/flaky-tests.jpg",
    description:
      "Automatically detect flaky tests that fail without code changes and reduce time spent investigating false failures."

  alias Tuist.Marketing.Stats

  def mount(params, session, socket) do
    if connected?(socket), do: Stats.subscribe()
    stats = Stats.get_stats()

    {:ok, socket} = super(params, session, socket)
    {:ok, assign(socket, :flaky_tests_detected, stats.flaky_tests_detected)}
  end

  def handle_info({:marketing_stats_updated, stats}, socket) do
    {:noreply, assign(socket, :flaky_tests_detected, stats.flaky_tests_detected)}
  end
end
