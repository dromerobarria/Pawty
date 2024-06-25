import SwiftUI

class LogStore: ObservableObject {
    static var shared:LogStore = LogStore()
    @Published var logs: [DailyLogs] = []
    
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("logStore.data")
    }
    
    public func getDirectory() throws -> String {
        let fileURL = try Self.fileURL()
        return fileURL.absoluteString
    }
    
    func load() async throws {
        do {
            let task = Task<[DailyLogs], Error> {
                let fileURL = try Self.fileURL()
                guard let data = try? Data(contentsOf: fileURL) else {
                    return []
                }
                let dailyScrums = try JSONDecoder().decode([DailyLogs].self, from: data)
                return dailyScrums
            }
            let logsData = try await task.value
            
            DispatchQueue.main.async {
                if logsData.count > LogStore.shared.logs.count {
                    self.logs = logsData
                }else {
                    self.logs = LogStore.shared.logs
                }
            }
        }catch{
            print("Error info: \(error)")
        }
      
    }
    
    func delete() async throws {
        let task = Task {
            let outfile = try Self.fileURL()
            do {
                try FileManager.default.removeItem(at: outfile)
            }catch{
                print("Error info: \(error)")
            }
        }
        
        do {
            _ = try await task.value
            DispatchQueue.main.async {
                LogStore.shared.logs = []
                self.logs = []
            }
           
        }catch{
            print("Error info: \(error)")
        }
      }
    
    func saves(logs: [DailyLogs]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(logs)
            let outfile = try Self.fileURL()
            do {
                try data.write(to: outfile)
            }catch{
                print("Error info: \(error)")
            }
        }
        
        do {
            _ = try await task.value
        }catch{
            print("Error info: \(error)")
        }
    }
    
    func addLog(log: DailyLogs) async {
        logs.append(log)
        print(logs.count)
    }
}



struct DailyLogs: Identifiable, Codable {
    let id: UUID
    var title: String
    var message: String
    var date: Date
    var category: LogType
    var info: [String]
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, message: String, date: Date = .now, category: LogType, info: [String] = [], theme: Theme = .yellow ) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.category = category
        self.info = info
        
        switch category {
        case .debug:
            self.theme = .yellow
        case .failed:
            self.theme = .yellow
        case .info:
            self.theme = .blue
        case .status:
            self.theme = .yellow
        case .success:
            self.theme = .green
        case .warning:
            self.theme = .red
        }
    }
}

enum Theme: String, CaseIterable, Identifiable, Codable {
    case blue
    case red
    case green
    case yellow
    
    var accentColor: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .green:
            return .green
        case .yellow:
            return .yellow
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }
}

enum LogType: Codable {
    case success
    case failed
    case info
    case warning
    case status
    case debug
}

extension DailyLogs {
    static let sampleData: [DailyLogs] =
    [
        DailyLogs (title: "Status Log",
                   message: "Access correctly",
                   category: .success,
                   info: ["username","lastname","lastname"]),
        DailyLogs (title: "Status Log",
                   message: "problem",
                   category: .warning,
                   info: ["username","username"]),
        DailyLogs (title: "Status Log",
                   message: "Access correctly",
                   category: .success),
    ]
}




