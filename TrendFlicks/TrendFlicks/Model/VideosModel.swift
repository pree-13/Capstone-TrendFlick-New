import Foundation

struct VideosModel: Codable {
  let id: Int
  let results: [VideoResult]
}

struct VideoResult: Codable {
  let iso6391: String
  let iso31661: String
  let name: String
  let key: String
  let site: String
  let size: Int
  let type: String
  let official: Bool
  let publishedAt: String
  let identifier: String

  enum CodingKeys: String, CodingKey {
    case iso6391 = "iso_639_1"
    case iso31661 = "iso_3166_1"
    case name, key, site, size, type, official
    case publishedAt = "published_at"
    case identifier = "id"
  }
}

extension VideoResult {
  var youtubeURL: URL? {
    return URL(string: "https://www.youtube.com/watch?v=\(key)")
  }
}
