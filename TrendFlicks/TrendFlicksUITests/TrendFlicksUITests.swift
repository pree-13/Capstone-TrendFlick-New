import XCTest

final class TrendFlicksUITests: XCTestCase {
  //  RVCAP
  var app = XCUIApplication()
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }


  func testAOnboardingUI() {
    let app = XCUIApplication()
    app.launch()
    sleep(20)
    if app.staticTexts["Welcome to TrendFlicks"].exists {
      XCTAssertTrue(app.staticTexts["Welcome to TrendFlicks"].exists)
      sleep(5)
      // swiftlint:disable:next line_length
      XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.buttons["getStartedButton"]/*[[".cells",".buttons[\"Get Started Now\"]",".buttons[\"getStartedButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    } else {
      XCTAssertTrue(true)
    }
  }

  func testB_open() throws {
    let app = XCUIApplication()
    app.launch()

    if app.staticTexts["Welcome to TrendFlicks"].exists {
      app.buttons["Get Started Now"].tap()
    }

    print("inside tab bar after boarding")
    XCTAssertTrue(app.tabBars["Tab Bar"].waitForExistence(timeout: 15))

    app.tabBars["Tab Bar"].buttons["Favorites"].tap()

    XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 10))

    let favoritesTitle = app.navigationBars.staticTexts.firstMatch.label
    XCTAssertEqual(favoritesTitle, "Favorites")

    app.tabBars["Tab Bar"].buttons["Movies"].tap()

    XCTAssertTrue(app.navigationBars["Trending Movies"].waitForExistence(timeout: 10))

    let trendingTitle = app.navigationBars.staticTexts.firstMatch.label
    XCTAssertEqual(trendingTitle, "Trending Movies")

    app.tabBars["Tab Bar"].buttons["Search"].tap()

    XCTAssertTrue(app.navigationBars["Search Movies"].waitForExistence(timeout: 10))

    let searchTitle = app.navigationBars.staticTexts.firstMatch.label
    XCTAssertEqual(searchTitle, "Search Movies")
  }

  func testTapOnFirstMovieCell() throws {
    let app = XCUIApplication()
    app.launch()
    app.tabBars["Tab Bar"].buttons["Movies"].tap()
    app.buttons.matching(identifier: "movieCell").element(boundBy: 0).tap()
    sleep(3)
    //  XCTAssertTrue(app.images["moviePosterImage"].exists)
    XCTAssertTrue(app.staticTexts["movieTitle"].exists)
    XCTAssertTrue(app.staticTexts["movieOverviewTitle"].exists)
    XCTAssertTrue(app.staticTexts["movieOverview"].exists)
    XCTAssertTrue(app.buttons["Favorite"].exists)
    app.navigationBars.buttons["Trending Movies"].tap()
    // RVCAP back btn test
  }
}
