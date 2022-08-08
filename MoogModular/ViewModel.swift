//
//  ViewModel.swift
//  MoogModular
//
//  Created by Oliver Foggin on 06/08/2022.
//

import Foundation
import AVFoundation

typealias Signal = (Float) -> (Float)

class Synth {
	public var volume: Float {
		set {
			audioEngine.mainMixerNode.outputVolume = newValue
		}
		get {
			return audioEngine.mainMixerNode.outputVolume
		}
	}
	private var audioEngine: AVAudioEngine
	private var time: Float = 0
	private let sampleRate: Double
	private let deltaTime: Float
	var signal: Signal

	private lazy var sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList in
		let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
		for frame in 0..<Int(frameCount) {
			let sampleVal = self.signal(self.time)
			self.time += self.deltaTime
			for buffer in ablPointer {
				let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
				buf[frame] = sampleVal
			}
		}
		return noErr
	}

	init(signal: @escaping Signal = Oscillator.sine) {
		self.signal = signal

		audioEngine = .init()

		let mainMixer = audioEngine.mainMixerNode
		let outputNode = audioEngine.outputNode
		let format = outputNode.inputFormat(forBus: 0)

		sampleRate = format.sampleRate
		deltaTime = 1 / Float(sampleRate)

		let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
		audioEngine.attach(sourceNode)
		audioEngine.connect(sourceNode, to: mainMixer, format: inputFormat)
		audioEngine.connect(mainMixer, to: outputNode, format: nil)

		mainMixer.outputVolume = 1
		do {
			print("starting")
			try audioEngine.start()
		} catch {
			print("Could not start engine: \(error.localizedDescription)")
		}
	}
}

struct Oscillator {
	static var amplitude: Float = 1
	static var frequency: Float = 440

	static let sine = { (time: Float) -> Float in
		return Oscillator.amplitude * sin(2.0 * Float.pi * Oscillator.frequency * time)
	}
}

class ViewModel: ObservableObject {
	@Published var isPlaying: Bool = false
	var synth: Synth?

	func play() {
		synth = Synth(signal: Oscillator.sine)
		synth?.volume = 1.0
	}
}
