//
//  HomeViewState.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

enum NewsViewEvent {
    case onAppear
}

enum NewsViewState: Equatable {
    case idle
    case loading
    case error(String)
    case loaded(ViewData)
    
    struct ViewData: Equatable {
        var newsItems: [EventModel]
    }
}
