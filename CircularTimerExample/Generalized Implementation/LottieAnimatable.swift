//
//  LottieAnimationStep.swift
//  CircularTimerExample
//
//  Created by Hugo Flores Perez on 9/26/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import Lottie
import UIKit

private let keyForFramerate = "fr"
private let keyForSteps = "op"

class LottieAnimatable<Value>: UIView where Value: BinaryInteger {
    
    private enum AnimationState {
        case initial
        case running
        case paused
        case stopped
    }
    
    private let animationView = AnimationView()
    
    private var animationState: AnimationState = .initial
    
    // Animation file related params
    private let totalProgress: Int
    private let fileFramerate: Int
    private var currentProgress: Int = 0
    
    // Tracking quantity/value
    private let maximumValue: Value
    private var currentValue: Value = .zero
    
    private var animationSpeed: CGFloat {
        CGFloat(Float(totalProgress) / Float(maximumValue)) / CGFloat(fileFramerate)
    }
    
    init(file: String, maximumValue: Value) {
        // For convenience, the animation file parameters are read from it
        guard
            let url = Bundle.main.url(forResource: file, withExtension: "json"),
            let animation = Animation.named(file)
        else {
            fatalError("Animation file with name: \(file), not found")
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]

            guard
                let fileFramerate = json[keyForFramerate] as? Int,
                let totalProgress = json[keyForSteps] as? Int
            else {
                fatalError("The animation file is malformed")
            }
            
            self.totalProgress = totalProgress
            self.fileFramerate = fileFramerate
        } catch {
            fatalError("Error parsing animation file data: \(error)")
        }

        self.maximumValue = maximumValue

        animationView.animation = animation
        
        super.init(frame: .zero)
        
        addSubview(animationView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = self.bounds
    }
    
    
    
    public func start() {
        start(stopAt: CGFloat(totalProgress), onFinish: nil)
    }
    
    public func start(stopAt: CGFloat, onFinish: (() -> Void)?) {
        if animationState == .running {
            return
        }
        
        animationState = .running
        
        startAnimation(from: 0, stopAt: stopAt, onFinish: onFinish)
    }
    
    private func startAnimation(from: CGFloat, stopAt: CGFloat, onFinish: (() -> Void)?) {
        self.animationView.play(fromProgress: from, toProgress: stopAt, loopMode: .playOnce) { (isFinished) in
            onFinish?()
        }
    }
}
