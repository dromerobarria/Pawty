import Foundation
import SwiftData

enum petType: Codable {
    case dog
    case cat
    case exotic
    
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .dog: return "DOG"
        case .cat: return "CAT"
        case .exotic: return "EXOTIC"
        }
      }
}

@Model
final class PetModel {
    
    @Attribute(.unique) var id: UUID
    var name : String
    var birthDay : Date
    var nickname : String
    var breed : String
    var kind : petType
    var time : Date?
    var image: Data?
    
    init(id: UUID = UUID(),name: String,birthDay: Date,nickname: String,breed: String ,time: Date? = nil, kind: petType, image: Data?) {
        self.id = id
        self.name = name
        self.birthDay = birthDay
        self.breed = breed
        self.nickname = nickname
        self.time = time
        self.kind = kind
        self.image = image
    }
    
    static func example() -> PetModel {
        let pet = PetModel(name: "Sofia", birthDay: Date(), nickname: "Sofi", breed: "Maltese", kind: .dog, image: nil)
        return pet
    }
}


