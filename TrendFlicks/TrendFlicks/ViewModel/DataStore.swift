import Foundation
import SwiftUI

class DataStore: ObservableObject {
  @Published var results: [Result] = []
  @Published var myFavorites: [FavoriteMovies] = []
  @Published var movies: [Result] = []
  @Published var isSearchQueryResultsNil = false
  @Published var isSearchError = false
  @Published var state: State = .initial

  let networkStore = NetworkStore()
  let localStore = LocalStore()

  public var favoritesFileURL: URL {
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      return documentDirectory.appendingPathComponent("favorites.json")
    } else {
      fatalError("Failed to get document directory URL")
    }
  }

  init() {
    self.myFavorites = loadFavorites()
  }

  func getData() async {
    do {
      let entries = try await networkStore.fetchData()
      await MainActor.run {
        //    results = data
        state = .success(data: entries)
      }
    } catch {
      await MainActor.run {
        state = .failed(error: error)
        print(error.localizedDescription)
      }
    }
  }
  // MARK: - Favorites
  public func saveFavorites() {
    do {
      try localStore.save(myFavorites: myFavorites)
    } catch let error {
      print(error)
    }
  }

  // Load favorites from the file system
  func loadFavorites() -> [FavoriteMovies] {
    do {
      let favorites = try localStore.getFavorites()
      return favorites
    } catch {
      print("Error loading favorites: \(error.localizedDescription)")
      return []
    }
  }

  // Add a favorite to the list and save to the file system
  func addFavorite(_ favorite: FavoriteMovies) {
    myFavorites.append(favorite)
    saveFavorites()
  }

  func removeFavorite(_ favorite: FavoriteMovies) {
    myFavorites.removeAll { $0.id == favorite.id }
    saveFavorites()
  }

  func isMovieInFavorites(movie: Result) -> Bool {
    myFavorites.contains { $0.id == movie.id }
  }

  func searchValue(searchQuery: String) async {
    do {
      await MainActor.run {
        self.movies = []
      }
      let data = try await  networkStore.search(query: searchQuery)
      await MainActor.run {
        self.movies = data
        if movies.isEmpty {
          isSearchQueryResultsNil.toggle()
        }
      }
    } catch {
      await MainActor.run {
        isSearchError = true
      }
      print(error)
    }
  }
}

extension DataStore {
  func watchTrailer(for movieResult: Result) {
    Task {
      do {
        if let videos = try await networkStore.fetchVideos(for: movieResult.id) {
          if let teaserVideo = videos.first(where: { $0.type == "Trailer" }) {
            let youtubeLink = "https://www.youtube.com/watch?v=\(teaserVideo.key )"
            if let url = URL(string: youtubeLink) {
              await MainActor.run {
                UIApplication.shared.open(url)
              }
            } else {
              print("Invalid YouTube URL")
            }
          } else {
            print("No video available")
          }
        }
      } catch {
        print("Error fetching videos: \(error)")
      }
    }
  }
}

extension DataStore {
  enum State {
    case initial
    case success(data: [Result])
    case failed(error: Error)
  }
}
