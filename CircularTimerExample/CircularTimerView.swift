//
//  CircularTimerView.swift
//  CircularTimerExample
//
//  Created by Hugo Flores Perez on 9/25/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import Lottie
import UIKit

enum TimerState {
    case initial
    case running
    case paused
    case stopped
}

class CircularTimerView: UIView {
    
    private let animationView = AnimationView()
    private let timerIndicator = UILabel()
    
    public var state: TimerState = .initial
    
    // Maximin time
    private var totalSeconds = 10
    
    // Variable time
    private var currentSeconds = 0
    
    // Animation file related params
    private let totalProgress: CGFloat = 900
    private var currentProgress: CGFloat = 0
    
    public var onPause: ((_ sec: Int) -> Void)?
    
    // Timers
    var timer: Timer?
    
    private var speed: CGFloat {
        CGFloat(Float(totalProgress) / Float(totalSeconds)) / 10 // <- This last number if the "framerate (?)" of the animation file. It's indicated in the "fr" key inside the json file
    }
    
    public convenience init(time: Int) {
        self.init(frame: .zero)
        totalSeconds = time
        animationView.animationSpeed = self.speed
        updateTime()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let animation: Animation = Animation.named("timer_lottie")!
        animationView.animation = animation
        animationView.animationSpeed = self.speed
        timerIndicator.textAlignment = .center
        timerIndicator.text = "0:00:00".uppercased()
        timerIndicator.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(animationView)
        self.addSubview(timerIndicator)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = self.bounds
        let h: CGFloat = self.frame.height
        let w: CGFloat = self.frame.width
        let x: CGFloat = (self.frame.width - w) / 2
        let y: CGFloat = (self.frame.height - h) / 2
        
        timerIndicator.frame = CGRect(x: x, y: y, width: w, height: h)
    }

    public func start() {
        if state == .running {
            return
        }
        
        self.state = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
            self.currentSeconds += 1
            self.updateTime()
        })
        
        self.animationView.play(fromProgress: 0, toProgress: totalProgress, loopMode: .playOnce) { (isFinished) in
            print("is Finished \(isFinished)")
        }
    }
    
    func updated() {
        if currentSeconds == totalSeconds {
            self.stop()
        }
    }
    
    public func stop() {
        if state == .stopped {
            return
        }
        self.state = .stopped
        self.currentSeconds = 0
        
        if self.animationView.isAnimationPlaying {
            self.animationView.stop()
        }
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func pause() {
        if state == .paused {
            return
        }
        self.state = .paused
        if self.animationView.isAnimationPlaying {
            self.animationView.pause()
        }
        let availableTime = self.currentSeconds
        let sec = availableTime
        self.onPause?(sec)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func updateTime() {
        let availableTime = totalSeconds - currentSeconds

        let msec = availableTime
        self.timerIndicator.text = ("\(msec)")
        self.updated()
    }
}
