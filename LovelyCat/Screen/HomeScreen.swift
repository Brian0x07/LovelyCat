//
//  HomeScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

// FIXME: Better implementation for handling favorites.
struct HomeScreen: View {
    @Environment(\.apiManager) private var apiManager
    
    @State private var tab: Tab = .images
    @StateObject private var favoritesVM = FavoritesViewModel()
    
    var body: some View {
        TabView(selection: $tab) {
            CatImageScreen(favoritesVM: favoritesVM)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.images)
            
            FavoriteScreen(favoritesVM: favoritesVM)
                .tabItem { Label("Favorite", systemImage: "heart.fill") }
                .tag(Tab.favorites)
        }
        .task {
            // FIXME: error handling
            try! await loadFavorites()
        }
    }
}


private extension HomeScreen {
    func loadFavorites() async throws {
        try await favoritesVM.getFavorites()
    }
}


private extension HomeScreen {
    enum Tab {
        case images, favorites
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environment(\.apiManager, .stub)
    }
}
