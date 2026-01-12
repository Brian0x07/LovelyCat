//
//  CatAPIManager+Env.swift
//  LovelyCat
//
//  Created by xiaolei on 1/12/26.
//

import SwiftUI

struct CatAPIManagerKey: EnvironmentKey {
    static var defaultValue: CatAPIManager = .shared
}

extension EnvironmentValues {
    var apiManager: CatAPIManager {
        get { self[CatAPIManagerKey.self] }
        set { self[CatAPIManagerKey.self] = newValue }
    }
}




