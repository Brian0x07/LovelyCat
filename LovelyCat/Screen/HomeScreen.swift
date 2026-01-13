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
    @State private var errorMessage: String?
    
    var body: some View {
        TabView(selection: $tab) {
            CatImageScreen(favoritesVM: favoritesVM)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.images)
            
            FavoriteScreen(favoritesVM: favoritesVM)
                .tabItem { Label("Favorite", systemImage: "heart.fill") }
                .tag(Tab.favorites)
        }
        .alert(errorMessage: $errorMessage)
        .task { await loadFavorites() }
    }
}


private extension HomeScreen {
    func loadFavorites() async {
        do {
            try await favoritesVM.getFavorites()
        } catch {
            errorMessage = "载入资料失败"
        }
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
            .environment(\.apiManager, .preview)
    }
}
