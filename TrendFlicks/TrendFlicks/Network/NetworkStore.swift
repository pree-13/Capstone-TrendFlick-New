import Foundation

class NetworkStore {
  var baseURL = "https://api.themoviedb.org/3"
  var additionalString = "/trending/movie/week"
  var additionalSearchString = "/search/movie?"
  private let session: URLSession
  private let sessionConfigauration: URLSessionConfiguration

  init() {
    self.sessionConfigauration = URLSessionConfiguration.default
    self.session = URLSession(configuration: sessionConfigauration)
  }

  func fetchData() async throws -> [Result] {
    let request = try await constructURL()
    guard let (data, response) = try? await self.session.data(for: request)
    else {
      throw DataStoreErrors.downloadFailed
    }

    guard let httpsResponse = response as? HTTPURLResponse,
      httpsResponse.statusCode == 200
    else {
      throw HTTPErrorCode.invalidStatusCode
    }

    do {
      let decodedData = try JSONDecoder().decode(MovieDataModel.self, from: data)
      return decodedData.results
    } catch {
      throw DataStoreErrors.decodingError
    }
  }

  func constructURL() async throws -> URLRequest {
    guard var urlComponents = URLComponents(string: baseURL + additionalString)
    else {
      throw HTTPErrorCode.invalidURL
    }

    urlComponents.queryItems = [
      URLQueryItem(name: "language", value: "en-US"),
      URLQueryItem(name: "page", value: "1")
    ]

    let urlString = urlComponents.url
    guard let url = urlString
    else {
      throw HTTPErrorCode.invalidURL
    }

    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = getHeaders()
    print(request)
    return request
  }

  func getHeaders() -> [String: String] {
    var apiKey: String {
      guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
        fatalError("Couldn't find file 'TMDB-Info.plist'.")
      }
      let plist = NSDictionary(contentsOfFile: filePath)
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
      }
      return value
    }
    let headers = [
      "accept": "application/json",
      "Authorization": apiKey
    ]
    return headers
  }

  func search(query: String) async throws -> [Result] {
    guard var urlComponents = URLComponents(string: baseURL + additionalSearchString)
    else {
      throw HTTPErrorCode.invalidURL
    }

    urlComponents.queryItems = [
      URLQueryItem(name: "query", value: query),
      URLQueryItem(name: "include_adult", value: "false"),
      URLQueryItem(name: "language", value: "en-US"),
      URLQueryItem(name: "page", value: "1")
    ]

    let urlString = urlComponents.url
    guard let url = urlString
    else { return [] }

    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = getHeaders()

    guard let (data, response) = try? await self.session.data(for: request)
    else { throw DataStoreErrors.downloadFailed }

    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
      else { throw HTTPErrorCode.invalidStatusCode }

    do {
      let decodedData = try JSONDecoder().decode(MovieDataModel.self, from: data)
      return decodedData.results
    } catch {
      throw DataStoreErrors.decodingError
    }
  }

  var baseMovieURL = "https://api.themoviedb.org/3/movie/"
    var additionalVideoString = "/videos"

    func constructVideoURL(for movieId: Int) -> URL? {
      let urlString = baseMovieURL + "\(movieId)" + additionalVideoString
      return URL(string: urlString)
    }

    func constructVideoURLRequest(for movieId: Int) throws -> URLRequest {
      guard let url = constructVideoURL(for: movieId) else {
        throw HTTPErrorCode.invalidURL
      }

      var request = URLRequest(url: url)
      request.allHTTPHeaderFields = getHeaders()
      return request
    }

    func fetchVideos(for movieId: Int) async throws -> [VideoResult]? {
      do {
        let request = try constructVideoURLRequest(for: movieId)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
          throw HTTPErrorCode.invalidStatusCode
        }

        let decoder = JSONDecoder()
        let videosResponse = try decoder.decode(VideosModel.self, from: data)
        print(videosResponse)
        return videosResponse.results
      } catch {
        throw error
      }
    }
}
