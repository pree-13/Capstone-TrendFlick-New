import SwiftUI

struct MovieSearchView: View {
  @State private var searchText = ""
  @ObservedObject private var dataStore: DataStore
  @State var fetchQueryTask: Task<Void, Error>?
  @MainActor @State var isDownloading = false
  internal init(dataStore: DataStore) {
    self.dataStore = dataStore
  }

  var body: some View {
    NavigationStack {
    List(dataStore.movies, id: \.self) { movie in
      NavigationLink(
        destination: DetailedMovieView(movieResult: movie, dataStore: dataStore)
      ) {
        MovieAddListRowView(
          favorites:
          FavoriteMovies(
          id: movie.id,
          title: movie.title,
          overview: movie.overview ?? "",
          posterPath: movie.posterPath ?? "",
          releaseDate: movie.releaseDate))
      }
    }
      .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find any Movie") {
      }
      .navigationTitle("Search Movies")
      .onSubmit(of: .search) {
        fetchQueryTask?.cancel()
        dataStore.isSearchQueryResultsNil = false
        dataStore.isSearchError = false
        fetchQueryTask = Task {
          isDownloading = true
          await  dataStore.searchValue(searchQuery: searchText)
          isDownloading = false
        }
      }
      .overlay {
        if dataStore.isSearchQueryResultsNil {
          ErrorView(error: "No Results Found")
        } else if dataStore.isSearchError {
          ErrorView(error: "Search failed")
        } else if isDownloading {
          ProgressView("Loading Movies...")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.thinMaterial)
        } else if searchText.isEmpty && dataStore.movies.isEmpty {
          EmptyFavoriteView(imageName: "magnifyingglass", infoText: "")
        }
      }
    }
  }
}

struct MovieSearchView_Previews: PreviewProvider {
  static var previews: some View {
    let dataStore = DataStore()
    MovieSearchView(dataStore: dataStore)
  }
}
