import XCTest
@testable import TrendFlicks
import SwiftUI

class DataStoreFavTests: XCTestCase {
  // swiftlint:disable:next implicitly_unwrapped_optional - disbaling for test
  var dataStore: DataStore!

  override func setUpWithError() throws {
  dataStore = DataStore()
  }

  override func tearDownWithError() throws {
    dataStore = nil
  }

  func testSaveFavorites() {
    let favorite = FavoriteMovies(
      id: 1,
      title: "Test Movie",
      overview: "Test Overview",
      posterPath: "test.jpg",
      releaseDate: "2023-01-01")

    dataStore.addFavorite(favorite)

    let loadedFavorites = dataStore.myFavorites
    XCTAssertTrue(loadedFavorites.contains { $0.id == favorite.id })
  }

  func testIsMovieInFavorites_WhenInFavorites() {
    // Arrange
    let movie = Result(
      adult: false,
      backdropPath: "/backdrop_path.jpg",
      id: 1,
      title: "Mock Movie",
      originalTitle: "Mock Movie",
      overview: "This is a mock movie.",
      posterPath: "/poster_path.jpg",
      genreIDS: [1, 2],
      popularity: 7.5,
      releaseDate: "2023-01-01",
      video: false,
      voteAverage: 8.0,
      voteCount: 100
    )

    dataStore.myFavorites = [
      FavoriteMovies(
        id: 1,
        title: "Test Movie",
        overview: "This is a test movie",
        posterPath: "/testposter.jpg",
        releaseDate: "2023-01-01"
      )
    ]

    XCTAssertTrue(dataStore.isMovieInFavorites(movie: movie), "Movie should be in favorites.")
  }

  func testIsMovieInFavorites_WhenNotInFavorites() {
    // Arrange
    let movie = Result(
      adult: false,
      backdropPath: "/backdrop_path.jpg",
      id: 1,
      title: "Mock Movie",
      originalTitle: "Mock Movie",
      overview: "This is a mock movie.",
      posterPath: "/poster_path.jpg",
      genreIDS: [1, 2],
      popularity: 7.5,
      releaseDate: "2023-01-01",
      video: false,
      voteAverage: 8.0,
      voteCount: 100
    )

    dataStore.myFavorites = [
      FavoriteMovies(
      id: 2,
      title: "Test Movie",
      overview: "This is a test movie",
      posterPath: "/testposter.jpg",
      releaseDate: "2023-01-01"
    )
    ]

    XCTAssertFalse(dataStore.isMovieInFavorites(movie: movie), "Movie should not be in favorites.")
  }

  func testIsMovieInFavorites_WhenEmptyFavorites() {
    let movie = Result(
      adult: false,
      backdropPath: "/backdrop_path.jpg",
      id: 1,
      title: "Mock Movie",
      originalTitle: "Mock Movie",
      overview: "This is a mock movie.",
      posterPath: "/poster_path.jpg",
      genreIDS: [1, 2],
      popularity: 7.5,
      releaseDate: "2023-01-01",
      video: false,
      voteAverage: 8.0,
      voteCount: 100
    )

    dataStore.myFavorites = []
    XCTAssertFalse(
      dataStore.isMovieInFavorites(movie: movie),
      "Movie should not be in favorites when favorites list is empty.")
  }
}

func testColorForRating() {
  let ratingBadge = RatingBadge(rating: 7.5)

  XCTAssertEqual(ratingBadge.colorForRating(7.5), Color.green)

  XCTAssertEqual(ratingBadge.colorForRating(5.0), Color.yellow)

  XCTAssertEqual(ratingBadge.colorForRating(3.0), Color.red)
}
