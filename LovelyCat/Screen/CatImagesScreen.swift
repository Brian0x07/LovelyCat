//
//  CatImagesScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageScreen: View {
    @Environment(\.apiManager) private var apiManager
    
    @ObservedObject var favoritesVM: FavoritesViewModel
    var favorites: [FavoriteItem] {
        favoritesVM.favorites
    }
    
    @State private var catImages: [CatImageViewModel] = []
    @State private var didFirstLoad: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("可愛貓咪")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                //FIXME: 不该等网络结束后才有动画
                Button("換一批") { Task { await loadRandomImages() } }
                    .buttonStyle(.bordered)
                    .font(.headline)
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                    CatImageView(catImage, isFavourited: isFavourited) {
                        Task {
                            // FIXME: error handling & pass async closure??
                            try! await toggleFavorite(catImage)
                        }
                    }
                }
            }
        }
        .task {
            if !didFirstLoad {
                await loadRandomImages()
                didFirstLoad = true
            }
        }
    }
}

private extension CatImageScreen {
    func loadRandomImages() async {
        // FIXME: error
        catImages = (try! await apiManager.getImages()).map (CatImageViewModel.init)
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async throws {
        guard let index = favorites.firstIndex(where: \.imageID == cat.id)  else {
            try await favoritesVM.add(cat)
            return
        }
        try await favoritesVM.remove(at: index)
    }
}


struct CatImageScreen_Previews: PreviewProvider, View {
    let vm = FavoritesViewModel()
    var body: some View {
        CatImageScreen(favoritesVM: vm)
    }
    
    static var previews: some View {
        Self()
            .environment(\.apiManager, .stub)
    }
}
