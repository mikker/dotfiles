# App scaffolding wiring

## Intent

Show how `TabView`, `NavigationStack`, and sheet routing fit together at the app root and per-tab level.

## Recommended wiring (root + per-tab)

```swift
@MainActor
struct AppView: View {
  @State private var selectedTab: AppTab = .timeline
  @State private var tabRouter = TabRouter()

  var body: some View {
    TabView(selection: $selectedTab) {
      ForEach(AppTab.allCases) { tab in
        let router = tabRouter.router(for: tab)
        NavigationStack(path: tabRouter.binding(for: tab)) {
          tab.makeContentView()
        }
        .withSheetDestinations(sheet: Binding(
          get: { router.presentedSheet },
          set: { router.presentedSheet = $0 }
        ))
        .environment(router)
        .tabItem { tab.label }
        .tag(tab)
      }
    }
  }
}
```

## Minimal AppTab skeleton

```swift
@MainActor
enum AppTab: Identifiable, Hashable, CaseIterable {
  case timeline
  case notifications
  case settings

  var id: String {
    switch self {
    case .timeline: return "timeline"
    case .notifications: return "notifications"
    case .settings: return "settings"
    }
  }

  @ViewBuilder
  func makeContentView() -> some View {
    switch self {
    case .timeline:
      TimelineView()
    case .notifications:
      NotificationsView()
    case .settings:
      SettingsView()
    }
  }

  @ViewBuilder
  var label: some View {
    switch self {
    case .timeline:
      Label("Timeline", systemImage: "rectangle.stack")
    case .notifications:
      Label("Notifications", systemImage: "bell")
    case .settings:
      Label("Settings", systemImage: "gear")
    }
  }
}
```

## Minimal RouterPath skeleton

```swift
@MainActor
@Observable
final class RouterPath {
  var path: [Route] = []
  var presentedSheet: SheetDestination?
}

enum Route: Hashable {
  case account(id: String)
  case status(id: String)
}
```

## Notes

- Each tab owns an independent navigation history via its own router.
- Sheets are routed from any child view by setting `router.presentedSheet`.
- Use the `TabRouter` pattern when tabs are data-driven; use one router per tab if tabs are fixed.

## Related references

- TabView: `references/tabview.md`
- NavigationStack: `references/navigationstack.md`
- Sheets: `references/sheets.md`
