import XCTest
@testable import Pawty

class LogStoreTests: XCTestCase {
  func testLoad() {
      let logStore = LogStore.shared
      let task = Task {
          try? await logStore.load()
          var isDirectory: ObjCBool = false
          XCTAssertTrue(FileManager.default.fileExists(atPath: try logStore.getDirectory(), isDirectory: &isDirectory))
      }
  }

  func testSave() {
      let logStore = LogStore.shared
      let task = Task {
          try? await logStore.saves(logs: [DailyLogs(title: "title", message: "message", category: .debug)])
          var isDirectory: ObjCBool = false
          XCTAssertTrue(FileManager.default.fileExists(atPath: try logStore.getDirectory(), isDirectory: &isDirectory))
      }
  }

  func testDelete() {
      let logStore = LogStore.shared
      let task = Task {
          try? await logStore.delete()
          var isDirectory: ObjCBool = false
          XCTAssertFalse(FileManager.default.fileExists(atPath: try logStore.getDirectory(), isDirectory: &isDirectory))
      }
  }
    
    func testAddLog(){
        let logStore = LogStore.shared
        logStore.logs = []
        let task = Task { await logStore.addLog(log: DailyLogs(title: "title", message: "message", category: .debug))
            XCTAssertEqual(logStore.logs.count, 1)
        }
    }
}
