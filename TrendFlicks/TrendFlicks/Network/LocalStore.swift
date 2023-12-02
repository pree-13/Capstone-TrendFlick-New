import Foundation

class LocalStore {
  public var favoritesFileURL: URL {
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      return documentDirectory.appendingPathComponent("favorites.json")
    } else {
      fatalError("Failed to get document directory URL")
    }
  }

  func save(myFavorites: [FavoriteMovies]) throws {
    do {
      let data = try JSONEncoder().encode(myFavorites)
      try data.write(to: favoritesFileURL)
    } catch {
      print("Error saving favorites: \(error.localizedDescription)")
      throw DataStoreErrors.saveFavoritesFailed
    }
  }

  // Load favorites from the file system
  func getFavorites() throws -> [FavoriteMovies] {
    do {
      let documentURL = URL(fileURLWithPath: "favorites", relativeTo: favoritesFileURL).appendingPathExtension("json")
      if FileManager.default.fileExists(atPath: documentURL.path) {
        let data = try Data(contentsOf: documentURL)
        let favorites = try JSONDecoder().decode([FavoriteMovies].self, from: data)
        return favorites
      } else {
        return []
      }
    } catch {
      print("Error loading favorites: \(error.localizedDescription)")
      throw DataStoreErrors.loadingFavoritesFailed
    }
  }
}
