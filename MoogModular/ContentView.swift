//
//  ContentView.swift
//  MoogModular
//
//  Created by Oliver Foggin on 06/08/2022.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: ViewModel

	var body: some View {
		Button {
			viewModel.play()
		} label: {
			viewModel.isPlaying
			? Label("Pause", systemImage: "pause")
			: Label("Play", systemImage: "play")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(viewModel: .init())
	}
}
