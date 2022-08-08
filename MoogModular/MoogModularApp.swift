//
//  MoogModularApp.swift
//  MoogModular
//
//  Created by Oliver Foggin on 06/08/2022.
//

import SwiftUI

@main
struct MoogModularApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView(viewModel: .init())
		}
	}
}
