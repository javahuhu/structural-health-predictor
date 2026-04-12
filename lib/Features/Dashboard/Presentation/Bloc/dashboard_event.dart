abstract class DashboardEvent {
  const DashboardEvent();
}

class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

class DashboardLoadMoreRequested extends DashboardEvent {
  const DashboardLoadMoreRequested();
}
