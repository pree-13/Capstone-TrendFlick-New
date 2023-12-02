import SwiftUI

struct MovieGridView: View {
  @ObservedObject var dataStore: DataStore
  @MainActor @State var isDownloading = false
  let columns = [
    GridItem(.adaptive(minimum: 150))
  ]

  var body: some View {
    NavigationStack {
      switch dataStore.state {
      case .success(let data):
        ScrollView {
          LazyVGrid(columns: columns) {
            ForEach(data) { movie in
              NavigationLink(destination: DetailedMovieView(movieResult: movie, dataStore: dataStore)) {
                ZStack(alignment: .topTrailing) {
                  VStack {
                    CardView(imageUrl: movie.posterURLPath, rating: movie.voteAverage)
                    Text(movie.title)
                      .foregroundColor(.primary)
                      .font(.headline)
                      .multilineTextAlignment(.center)
                      .padding(.top, 8)
                      .padding(.horizontal, 8)
                  }
                }
              }
              .buttonStyle(.plain)
              .accessibility(identifier: "movieCell")
            }
          }
          .padding()
          .navigationTitle("Trending Movies")
        }
      case .failed(error: let error):
        //   print(error)
        ErrorView(error: "Something went wrong - \(error)")
          .navigationTitle("Trending Movies")
      default:
        ProgressView("Loading Movies...")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.thinMaterial)
      }
    }
    .task {
      await dataStore.getData()
    }
  }
}

struct MovieGridView_Previews: PreviewProvider {
  static var previews: some View {
    MovieGridView(dataStore: DataStore())
  }
}
