import SwiftUI

struct CardView: View {
  var imageUrl: URL?
  var rating: Double

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      AsyncImage(url: imageUrl) { phase in
        switch phase {
        case .empty:
          ProgressView()
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 200)
            .cornerRadius(10)
        case .failure:
          Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 200)
            .cornerRadius(10)
        @unknown default:
          EmptyView()
        }
      }
      .shadow(radius: 5)
      RatingBadge(rating: rating)
        .background(
          Circle()
            .fill(Color(.systemBackground))
        )
        .padding(EdgeInsets(top: 10, leading: 10, bottom: -20, trailing: -20))
    }
  }
}

struct RatingBadge: View {
  var rating: Double

  func colorForRating(_ rating: Double) -> Color {
    switch rating {
    case let rate where rate >= 7.0:
      return Color.green
    case let rate where rate > 4.0:
      return Color.yellow
    default:
      return Color.red
    }
  }

  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 4)
        .opacity(0.2)
        .foregroundColor(Color.gray)

      Circle()
        .trim(from: 0.0, to: CGFloat(rating / 10))
        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
        .foregroundColor(colorForRating(rating))
        .rotationEffect(Angle(degrees: -90.0))

      Text(String(format: "%.1f", rating))
        .font(.caption)
        .foregroundColor(colorForRating(rating))
    }
    .frame(width: 30, height: 30)
    .padding(8)
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    let url = URL(string: "https://www.themoviedb.org/t/p/original/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg")
    // swiftlint:disable:next force_unwrapping - as this is preview and URL is set in above line disabling Lint rule
    CardView(imageUrl: url!, rating: 7.161)
  }
}
