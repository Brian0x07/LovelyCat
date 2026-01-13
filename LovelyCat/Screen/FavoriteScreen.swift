//
//  FavoriteScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct FavoriteScreen: View {
    @ObservedObject var favoritesVM: FavoritesViewModel
    @State private var errorMessage: String?
    
    var favorites: [FavoriteItem] {
        favoritesVM.favorites
    }
    
    var body: some View {
        VStack {
            Text("我的最愛")
                .font(.largeTitle.bold())
            
            ScrollView {
                if favorites.isEmpty {
                    Text("雙擊圖片即可新增到最愛喲 😊")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: favorites.isEmpty ? 0 : -UIScreen.main.bounds.maxX)
                        .font(.title3)
                        .padding()
                }
                
                ForEach(Array(favorites.enumerated()), id: \.element.imageID) { index, favoriteItem in
                    CatImageView(.init(favoriteItem: favoriteItem), isFavourited: true) {
                        do {
                            try await favoritesVM.remove(at: index)
                        } catch {
                            errorMessage = "无法移除最爱项"
                        }
                    }.transition(.slide)
                }
            }
        }
        .animation(.spring(), value: favorites)
        .alert(errorMessage: $errorMessage)
    }
}


struct FavoriteScreen_Previews: PreviewProvider, View {
    private var favorites: [FavoriteItem] = [CatImageViewModel].stub.enumerated().map { FavoriteItem(catImage: $0.element, id: $0.offset) }
    var body: some View {
        let vm = FavoritesViewModel()
        vm.setFavorites(favorites)
        return FavoriteScreen(favoritesVM: vm)
    }
    
    static var previews: some View {
        Self()
            .environment(\.apiManager, .preview)
    }
}
