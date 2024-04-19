//
//  CatOrDogV1App.swift
//  CatOrDogV1
//
//  Created by Liu, Emily on 4/8/24.
//

import SwiftUI

@main
struct CatOrDogV1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: AnimalModel())
        }
    }
}
