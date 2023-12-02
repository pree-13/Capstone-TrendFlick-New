import SwiftUI

struct MovieAddListView: View {
  @ObservedObject var dataStore: DataStore

  var body: some View {
    NavigationStack {
      VStack {
        if dataStore.myFavorites.isEmpty {
          EmptyFavoriteView(imageName: "heart.fill", infoText: "No Favorites yet. Go to Search and add your favorites")
            .multilineTextAlignment(.center)
        } else {
          List {
            ForEach(dataStore.myFavorites) { result in
              MovieAddListRowView(
                favorites: FavoriteMovies(
                  id: result.id,
                  title: result.title,
                  overview: result.overview,
                  posterPath: result.posterPath,
                  releaseDate: result.releaseDate
                )
              )
            }
            .onDelete(perform: deleteMovie)
          }
          .listStyle(PlainListStyle())
          .padding(.horizontal, -5)
          .scrollContentBackground(.hidden)
        }
      }
      .navigationTitle("Favorites")
    }
  }
  func deleteMovie(at offsets: IndexSet) {
    for index in offsets {
      let favoriteToRemove = dataStore.myFavorites[index]
      dataStore.removeFavorite(favoriteToRemove)
    }
  }
}

struct MovieAddListView_Previews: PreviewProvider {
  static var previews: some View {
    MovieAddListView(dataStore: DataStore())
  }
}

struct EmptyFavoriteView: View {
  var imageName: String
  var infoText: String
  var body: some View {
    VStack {
      Image(systemName: imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .opacity(0.25)

      Text(infoText)
        .font(.title3)
        .foregroundColor(.accentColor)
        .opacity(0.65)
        .padding()
    }
  }
}
