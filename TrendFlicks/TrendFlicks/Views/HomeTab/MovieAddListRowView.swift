import SwiftUI

struct MovieAddListRowView: View {
  let favorites: FavoriteMovies
  var body: some View {
    HStack(spacing: 50) {
      VStack(alignment: .leading, spacing: 8) {
        AsyncImage(url: favorites.posterURLPath) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 80, height: 120)
              .cornerRadius(10)
          case .failure:
            Image(systemName: "photo")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 80, height: 120)
              .cornerRadius(10)
          case .empty:
            ProgressView()
          @unknown default:
            EmptyView()
          }
        }
        .frame(width: 80, height: 80)
        .cornerRadius(10)
      }

      VStack(alignment: .leading, spacing: 8) {
        Text(favorites.title)
          .font(.headline)
          .foregroundColor(.primary)
        Text("Release Date: \(favorites.releaseDate)")
          .foregroundColor(.primary)
      }
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
    .cornerRadius(12)
    .shadow(radius: 4)
  }
}

struct MovieAddListRowView_Previews: PreviewProvider {
  static var previews: some View {
    let favorite = FavoriteMovies.init(
      id: 27205,
      title: "Inception",
      overview: "Cobb, a skilled thief who commits corporate espionage by infiltrating the subconscious of his targets",
      posterPath: "/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg",
      releaseDate: "2010-07-15")
    MovieAddListRowView(favorites: favorite)
  }
}
