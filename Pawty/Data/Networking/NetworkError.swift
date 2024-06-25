import Foundation

enum NetworkError: LocalizedError {
    case noConnect
    case invalidData
    case requestFailed
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .noConnect:
            return "NoConnect"
        case .invalidResponse:
            return "InvalidResponse"
        case .invalidData:
            return "InvalidData"
        case .requestFailed:
            return "RequestFailed"
        }
    }
}
