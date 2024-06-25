import Foundation

final class FetchPetListUseCase {

    private let petRepository: PetRepository

    init(petRepository: PetRepository) {
        self.petRepository = petRepository
    }

    func execute() async throws -> [PetModel] {
        let pets = try await petRepository.getPetList()
        return pets
    }
    
    func executeEvents() async throws -> [EventModel] {
        let events = try await petRepository.getEventList()
        return events
    }
}

