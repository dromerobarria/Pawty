//
//  LiveCoordinator.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import Foundation

final class AdoptCoordinator: Coordinator {
    enum Screen: Routable {}
    
    @Published var navigationPath = [Screen]()
    
    init() {}
}

extension AdoptCoordinator: AdoptCoordinatorProtocol {}
