import Foundation

// MARK: - DataModel
struct MovieDataModel: Codable, Hashable {
  let page: Int
  let results: [Result]
  let totalPages: Int
  let totalResults: Int
  enum CodingKeys: String, CodingKey {
    case page, results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}
// @RVCAP check model once
// MARK: - Result
struct Result: Codable, Identifiable, Hashable {
  let adult: Bool
  let backdropPath: String?
  let id: Int
  let title: String
  let originalTitle, overview, posterPath: String?
  let genreIDS: [Int]
  let popularity: Double
  let releaseDate: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  var posterURLPath: URL? {
    return "https://image.tmdb.org/t/p/w500\(posterPath ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      .flatMap { URL(string: $0) }
  }
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case id, title
    case originalTitle = "original_title"
    case overview
    case posterPath = "poster_path"
    case genreIDS = "genre_ids"
    case popularity
    case releaseDate = "release_date"
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
}

struct FavoriteMovies: Codable, Identifiable, Equatable {
  var id: Int
  var title: String
  var overview: String
  var posterPath: String
  let releaseDate: String
  var posterURLPath: URL? {
    return "https://image.tmdb.org/t/p/w500\(posterPath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      .flatMap { URL(string: $0) }
  }
}
