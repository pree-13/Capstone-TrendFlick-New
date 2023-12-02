import SwiftUI

struct MovieInfoView: View {
  var movieResult: Result
  @ObservedObject var dataStore: DataStore
  @State var isAnimating = false
  let networkStore = NetworkStore()

  func toggleFavorite() {
    let favorite = FavoriteMovies(
      id: movieResult.id,
      title: movieResult.title,
      overview: movieResult.overview ?? "",
      posterPath: movieResult.posterPath ?? "",
      releaseDate: movieResult.releaseDate)

    if dataStore.isMovieInFavorites(movie: movieResult) {
      dataStore.removeFavorite(favorite)
    } else {
      dataStore.addFavorite(favorite)
    }
  }

  var body: some View {
    LazyVStack(alignment: .leading, spacing: 10) {
      Text(movieResult.title)
        .font(.title2)
        .fontWeight(.bold)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityIdentifier("movieTitle")

      Button {
        withAnimation(.easeInOut) {
          toggleFavorite()
          self.isAnimating.toggle()
        }
      } label: {
        HStack {
          Image(systemName: dataStore.isMovieInFavorites(movie: movieResult) ? "heart.fill" : "heart")
            .font(.title2)
            .symbolRenderingMode(.palette)
            .foregroundColor(dataStore.isMovieInFavorites(movie: movieResult) ? .red : .primary)
            .scaleEffect(isAnimating ? 1.4 : 1.0)
          Text("Favorite")
            .padding(.trailing)
          Button {
            withAnimation(.easeInOut(duration: 0.5)) {
              dataStore.watchTrailer(for: movieResult)
            }
          } label: {
            Image(systemName: "play.rectangle.fill")
            Text("Trailer")
          }
          .buttonStyle(BorderlessButtonStyle())
        }
      }
      .buttonStyle(BorderlessButtonStyle())
      .padding(.leading, 5)

      Text("Release Date: \(movieResult.releaseDate)")
        .font(.subheadline)
        .foregroundColor(.gray)

      Text("Overview:")
        .font(.headline)
        .fontWeight(.medium)
        .padding(.top, 5)
        .accessibilityIdentifier("movieOverviewTitle")

      Text(movieResult.overview ?? "No overview available.")
        .font(.body)
        .foregroundColor(.secondary)
        .accessibilityIdentifier("movieOverview")
    }
  }
}

struct MovieInfoView_Previews: PreviewProvider {
  static var previews: some View {
    let result = Result(
      adult: false,
      backdropPath: "/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg",
      id: 27205,
      title: "Inception",
      originalTitle: "Inception",
      overview: "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets",
      posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
      genreIDS: [28, 878, 12],
      popularity: 154.283,
      releaseDate: "2010-07-15",
      video: false,
      voteAverage: 8,
      voteCount: 34796)
    let dataStore = DataStore()
    MovieInfoView(movieResult: result, dataStore: dataStore, isAnimating: false)
  }
}
