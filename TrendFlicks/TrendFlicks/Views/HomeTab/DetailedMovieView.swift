import Foundation
import SwiftUI

struct DetailedMovieView: View {
  var movieResult: Result
  @ObservedObject var dataStore: DataStore
  @State var isAnimating = false
  @Environment(\.verticalSizeClass)
  var verticalSizeClass
  @Environment(\.horizontalSizeClass)
  var horizontalSizeClass

  var body: some View {
    ScrollView {
      if verticalSizeClass == .compact {
        HStack(spacing: 0) {
          ExtractAsyncImageView(movieResult: movieResult, dataStore: dataStore)
        }
        .padding(5)
      } else {
        VStack(spacing: 0) {
          ExtractAsyncImageView(movieResult: movieResult, dataStore: dataStore)
        }
        .padding(5)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct DetailedMovieView_Previews: PreviewProvider {
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
      DetailedMovieView(movieResult: result, dataStore: dataStore)
  }
}

struct ExtractAsyncImageView: View {
  var movieResult: Result
  @State var isImageLoaded = false
  @ObservedObject var dataStore: DataStore

  var body: some View {
    AsyncImage(url: movieResult.posterURLPath) { phase in
      if let image = phase.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .frame(width: 320, height: 320)
          .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
              self.isImageLoaded = true
            }
          }
      } else if phase.error != nil {
        Image(systemName: "photo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: 320)
      } else {
        ProgressView()
          .frame(maxHeight: 320)
      }
    }
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.clear, lineWidth: 2)
    )
    .opacity(isImageLoaded ? 1 : 0)
    Spacer()
    MovieInfoView(movieResult: movieResult, dataStore: dataStore)
  }
}
