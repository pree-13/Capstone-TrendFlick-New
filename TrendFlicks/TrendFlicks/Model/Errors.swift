import Foundation

enum DataStoreErrors: Error {
  case downloadFailed
  case decodingError
  case loadingFavoritesFailed
  case saveFavoritesFailed
}
