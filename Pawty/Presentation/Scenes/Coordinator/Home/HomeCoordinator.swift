//
//  EventCoordinator.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import Foundation

final class HomeCoordinator: Coordinator {
    
    enum Screen: Routable {
        case PetDetails(PetModel)
    }
    
    @Published var navigationPath = [Screen]()
    
    init() {}
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    func PetDetails(_ pet: PetModel) {
        navigationPath.append(.PetDetails(pet))
    }
}

