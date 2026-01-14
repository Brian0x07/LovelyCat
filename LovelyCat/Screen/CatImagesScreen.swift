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
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    
    var body: some View {
        VStack {
            HStack {
                Text("可愛貓咪")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("换一批", action: loadRandomImages)
                    .buttonStyle(.bordered)
                    .font(.headline)
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
                    .disabled(isLoading)
            }.padding(.horizontal)
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(catImages) { catImage in
                        let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                        CatImageView(catImage, isFavourited: isFavourited) {
                            await toggleFavorite(catImage)
                        }.id(catImage.id)
                    }
                }.onChange(of: catImages.first?.id) { newID in
                    guard let newID else { return }
                    withAnimation {
                        proxy.scrollTo(newID)
                    }
                }
            }
        }
        .alert(errorMessage: $errorMessage)
        .onAppear {
            if !catImages.isEmpty && !isLoading { return }
            loadRandomImages()
        }
    }
}

private extension CatImageScreen {
    func loadRandomImages() {
        Task {
            do {
                isLoading = true
                catImages = (try await apiManager.getImages()).map (CatImageViewModel.init)
            } catch {
                errorMessage = "无法载入图片"
            }
            isLoading = false
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
