//
//  MainCoordinatorView.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 30-01-24.
//

import SwiftUI

struct MainCoordinatorView: View {

    enum Tab {
        case home
        case favorites
        case live
        case news
    }

    @State private var selectedTab = Tab.home

    private let factory: ScreenFactory
    private let homeCoordinator: HomeCoordinator
    private let calendarCoordinator: CalendarCoordinator
    private let newsCoordinator: NewsCoordinator
    private let adoptCoordinator: AdoptCoordinator

    init(factory: ScreenFactory) {
        self.factory = factory

        homeCoordinator = .init()
        calendarCoordinator = .init()
        newsCoordinator = .init()
        adoptCoordinator = .init()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeCoordinatorView(homeCoordinator, factory: factory)
                .tabItem {
                    Label("Pets", systemImage: Constants.pet)
                }
                .tag(Tab.home)
            
            CalendarCoordinatorView(calendarCoordinator, factory: factory)
                .tabItem {
                    Label("Calendario", systemImage: Constants.calendar)
                }
                .tag(Tab.favorites)
            
            NewsCoordinatorView(newsCoordinator, factory: factory)
                .tabItem {
                    Label("News", systemImage: Constants.newspaper)
                }
                .tag(Tab.news)
            
            AdoptCoordinatorView(adoptCoordinator, factory: factory)
                .tabItem {
                    Label("Adopt", systemImage: Constants.teddybear)
                }
                .tag(Tab.live)
        }
        .tint(.appAccent)
        .onAppear {
            setupTabBar()
        }
    }

    private enum Constants {
        static let pet = "pawprint.circle"
        static let calendar = "calendar"
        static let newspaper = "newspaper"
        static let teddybear = "teddybear"
    }

    @MainActor private func setupTabBar() {
        UITabBar.appearance().tintColor = UIColor(resource: .appAccent)
        UITabBar.appearance().isTranslucent = true

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
    }
}
