import Foundation
import SwiftData

enum eventType: Codable {
    case medicament
    case veterinary
    case operation
    
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .medicament: return "Medicament"
        case .veterinary: return "Veterinary"
        case .operation: return "Operation"
        }
      }
}

@Model
final class EventModel {
    
    @Attribute(.unique) var id: UUID
    var name : String
    var date : Date
    var location : String
    var detail : String
    var kind : eventType
    
    init(id: UUID = UUID(),name: String,date: Date,location: String,detail: String, kind : eventType) {
        self.id = id
        self.name = name
        self.date = date
        self.location = location
        self.kind = kind
        self.detail = detail
    }
    
    static func example() -> EventModel {
        let event = EventModel(name: "Vet Sofi", date: Date(), location: "Tus mascotas", detail: "vacuna sofi", kind: .veterinary)
        return event
    }
}


