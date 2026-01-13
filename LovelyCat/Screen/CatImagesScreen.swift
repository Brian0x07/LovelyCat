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
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    
    var body: some View {
        VStack {
            HStack {
                Text("可愛貓咪")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("換一批") { Task { await loadRandomImages() } }
                    .buttonStyle(.bordered)
                    .font(.headline)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .disabled(isLoading)
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                    CatImageView(catImage, isFavourited: isFavourited) {
                        await toggleFavorite(catImage)
                    }
                }
            }
        }
        .alert(errorMessage: $errorMessage)
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
        do {
            defer {
                isLoading = false
            }
            isLoading = true
            catImages = (try await apiManager.getImages()).map (CatImageViewModel.init)
        } catch {
            errorMessage = "无法载入图片"
        }
    }
    
    func toggleFavorite(_ cat: CatImageViewModel) async {
        do {
            guard let index = favorites.firstIndex(where: \.imageID == cat.id)  else {
                try await favoritesVM.add(cat)
                return
            }
            try await favoritesVM.remove(at: index)
        } catch {
            errorMessage = "无法更新最爱"
        }
    }
}


struct CatImageScreen_Previews: PreviewProvider, View {
    let vm = FavoritesViewModel()
    var body: some View {
        CatImageScreen(favoritesVM: vm)
    }
    
    static var previews: some View {
        Self()
            .environment(\.apiManager, .preview)
    }
}
