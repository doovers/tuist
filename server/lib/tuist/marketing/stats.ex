defmodule Tuist.Marketing.Stats do
  @moduledoc """
  A GenServer that periodically polls ClickHouse for marketing page statistics
  and broadcasts updates via PubSub. LiveViews subscribe to receive fresh values
  without each page visit hitting the database.
  """

  use GenServer

  @topic "marketing_stats"
  @poll_interval to_timeout(second: 5)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_stats do
    GenServer.call(__MODULE__, :get_stats)
  end

  def subscribe do
    Tuist.PubSub.subscribe(@topic)
  end

  @impl true
  def init(_) do
    stats = %{
      cache_artifacts_today: 0,
      total_builds: 0,
      total_test_case_runs: 0,
      total_test_runs: 0,
      flaky_tests_detected: 0
    }

    send(self(), :poll)
    {:ok, stats}
  end

  @impl true
  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  @impl true
  def handle_info(:poll, _stats) do
    stats = %{
      cache_artifacts_today: Tuist.Cache.today_artifacts_count(),
      total_builds: Tuist.Builds.total_count(),
      total_test_case_runs: Tuist.Tests.total_test_case_run_count(),
      total_test_runs: Tuist.Tests.total_test_run_count(),
      flaky_tests_detected: Tuist.Tests.flaky_test_case_run_count()
    }

    Tuist.PubSub.broadcast(stats, @topic, :marketing_stats_updated)
    Process.send_after(self(), :poll, @poll_interval)
    {:noreply, stats}
  end
end
