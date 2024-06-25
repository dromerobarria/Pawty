import Foundation
import SwiftData

final class AppFactory {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    private lazy var EventRepository:PetsRepositoryImplementation = {
        return PetsRepositoryImplementation(modelContext: modelContext)
    }()
}

// MARK: - Event

extension AppFactory {

    func makeFetchPetsUseCase() -> FetchPetListUseCase {
        FetchPetListUseCase(petRepository: EventRepository)
    }
}
