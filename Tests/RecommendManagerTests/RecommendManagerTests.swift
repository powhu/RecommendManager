    import XCTest
    @testable import RecommendManager

    final class RecommendManagerTests: XCTestCase {
        func testExample() {
            XCTAssert(!RecommendManager.RecommendAppManager().apps.isEmpty)
        }
    }
