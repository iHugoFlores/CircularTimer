//
//  ViewController.swift
//  CircularTimerExample
//
//  Created by Hugo Flores Perez on 8/24/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

import Lottie
import UIKit

class ViewController: UIViewController {
    
//    private let timerView = CircularTimerView(time: 11)
    
    let myView = LottieAnimatable<Int>(file: "timer_lottie", maximumValue: 10)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

//        view.addSubview(timerView)
//        timerView.translatesAutoresizingMaskIntoConstraints = false
//
//        timerView.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        timerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
//        timerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
//        timerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
//
//        timerView.start()
    }
}

