//
//  View+MyFriendlyError.swift
//  LovelyCat
//
//  Created by xiaolei on 1/13/26.
//

import SwiftUI

private struct MyFriendlyError: LocalizedError {
    var errorDescription: String?
    
    init?(errorDescription: String? = nil) {
        guard let errorDescription else { return nil }
        self.errorDescription = errorDescription
    }
}

extension View {
    func alert(errorMessage: Binding<String?>) -> some View {
        alert(isPresented: Binding(
            get: { errorMessage.wrappedValue != nil },
            set: { _ in errorMessage.wrappedValue = nil}
        ), error: MyFriendlyError(errorDescription: errorMessage.wrappedValue)) { }
    }
}
