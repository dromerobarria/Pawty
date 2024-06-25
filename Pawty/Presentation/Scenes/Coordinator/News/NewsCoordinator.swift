//
//  NewsCoordinator.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import Foundation

final class NewsCoordinator: Coordinator {
    enum Screen: Routable {}
    
    @Published var navigationPath = [Screen]()
    
    init() {}
}

extension NewsCoordinator: NewsCoordinatorProtocol {}

