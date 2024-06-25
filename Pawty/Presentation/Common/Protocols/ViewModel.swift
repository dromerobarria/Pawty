//
//  ViewModel.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 29-01-24.
//

import Foundation

@MainActor
protocol ViewModel<State, Event>: ObservableObject where State: Equatable {
    associatedtype State
    associatedtype Event

    var state: State { get }
    
    func handle(_ event: Event)
}
