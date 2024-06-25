enum HomeViewEvent {
    case onAppear
}

enum HomeViewState: Equatable {
    case idle
    case loading
    case error(String)
    case loaded(ViewData)
    
    struct ViewData: Equatable {
        var petItems: [PetModel]
    }
}
