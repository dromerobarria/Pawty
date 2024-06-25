import Foundation

protocol PetRepository {
    func getPetList() async throws -> [PetModel]
    func getEventList() async throws -> [EventModel] 
}
