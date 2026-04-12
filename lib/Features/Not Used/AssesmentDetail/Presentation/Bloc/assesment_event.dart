abstract class InspectionEvent {
  const InspectionEvent();
}

class WatchInspectionLogsStarted extends InspectionEvent {
  const WatchInspectionLogsStarted();
}

class LoadMoreInspectionLogsRequested extends InspectionEvent {
  const LoadMoreInspectionLogsRequested();
}
