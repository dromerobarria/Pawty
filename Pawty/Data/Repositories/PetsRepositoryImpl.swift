import Foundation
import SwiftUI
import SwiftData

final class PetsRepositoryImplementation: @unchecked Sendable {
    var modelContext: ModelContext? = nil
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}

extension PetsRepositoryImplementation: PetRepository {
   
    func getPetList() async throws -> [PetModel] {
        guard NetworkMonitor.shared.isConnected else { throw NetworkError.noConnect }
        let fetchDescriptor = FetchDescriptor<PetModel>()
        
        do {
            let pets = try modelContext?.fetch(fetchDescriptor) ?? []
            return pets
        } catch {
            return []
        }
    }
    
    func getEventList() async throws -> [EventModel] {
        let fetchDescriptor = FetchDescriptor<EventModel>()
        
        do {
            let events = try modelContext?.fetch(fetchDescriptor) ?? []
            return events
        } catch {
            return []
        }
    }
}
