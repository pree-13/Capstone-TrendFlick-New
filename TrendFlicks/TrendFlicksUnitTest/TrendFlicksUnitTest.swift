import XCTest
import SwiftUI
@testable import TrendFlicks

final class TrendFlicksUnitTest: XCTestCase {
  var dataStore = DataStore()
  var network = NetworkStore()
  let timeout: TimeInterval = 5

  var expectation = XCTestExpectation()  // var expectation: XCTestExpectation!
  let mockMovieDataModel = MovieDataModel(
    page: 1,
    results: [
      Result(
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
    ],
    totalPages: 1,
    totalResults: 1
  )
  let mockFavoriteMovie = FavoriteMovies(
    id: 1,
    title: "Mock Favorite Movie",
    overview: "This is a mock favorite movie.",
    posterPath: "/favorite_poster_path.jpg",
    releaseDate: "2023-01-01"
  )
  let mockResult = Result(
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
  override func setUpWithError() throws {
    try super.setUpWithError()
    dataStore = DataStore()
  }
  override func setUp() {
    expectation = expectation(description: "Server responds in reasonable time")
  }

  func test_noServerResponse() {
    // swiftlint:disable:next force_unwrapping - as  URL is set in below line disabling Lint rule
    let url = URL(string: "doggone")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }
      XCTAssertNil(data)
      XCTAssertNil(response)
      XCTAssertNotNil(error)
    }
    .resume()
    waitForExpectations(timeout: timeout)
  }
  func testDecode_Movie() {
    // swiftlint:disable:next force_unwrapping - as  URL is set in below line disabling Lint rule
    let url = URL(string: "https://api.themoviedb.org/3/trending/movie/week?language=en-US&page=1")!

    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = network.getHeaders()

    URLSession.shared.dataTask(with: request) { data, response, error in
      defer { self.expectation.fulfill() }
      XCTAssertNil(error)
      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 200)
        let data = try XCTUnwrap(data)
        XCTAssertNoThrow(
          try JSONDecoder().decode(MovieDataModel.self, from: data)
        )
      } catch {
        XCTFail("Error: \(error)")
      }
    }
    .resume()
    waitForExpectations(timeout: timeout)
  }

  func test_404() {
    // swiftlint:disable:next force_unwrapping - as  URL is set in below line disabling Lint rule
    let url = URL(string: "https://rawcdn.githack.com/raywenderlich/video-ti-materials/versions/5.0/15-test-doubles/Final/DogPatch/DogPatchTests/cats.json")!

    URLSession.shared.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }

      XCTAssertNil(error)

      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 404)

        let data = try XCTUnwrap(data)
        XCTAssertThrowsError(
          try JSONDecoder().decode(MovieDataModel.self, from: data)
        ) { error in
          guard case DecodingError.dataCorrupted = error else {
            XCTFail("\(error)")
            return
          }
        }
      } catch { }
    }
    .resume()

    waitForExpectations(timeout: 10)
  }
}
