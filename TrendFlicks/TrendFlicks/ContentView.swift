import SwiftUI

struct ContentView: View {
  @ObservedObject var dataStore: DataStore
  @AppStorage("TaskStatusCurrentTab")
  var selectedTab = 0
  var body: some View {
    TabView(selection: $selectedTab) {
      MovieGridView(dataStore: dataStore)
        .tabItem {
          Image(systemName: "square.grid.2x2")
          Text("Movies")
        }
        .tag(0)
      MovieAddListView(dataStore: dataStore)
        .tabItem {
          Image(systemName: "heart.text.square.fill")
          Text("Favorites")
        }
        .tag(1)
      MovieSearchView(dataStore: dataStore)
        .tabItem {
          Image(systemName: "magnifyingglass")
          Text("Search")
        }
        .tag(2)
    }
    .navigationTitle("Movies")
    .accessibilityIdentifier("ContentView")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(dataStore: DataStore())
  }
}
