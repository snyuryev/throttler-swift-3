//
//  ViewController.swift
//  Throttler
//
//  Created by Sergey Yuryev on 02/02/2017.
//  Copyright © 2017 syuryev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer?
    
    var callNumber = 0
    
    let throttler = Throttler(interval: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }

    func timerUpdate() {
        let ts = Date.nowTs()
        self.callNumber += 1
        print("timer call \(ts) callNumber \(self.callNumber)")
        self.throttler.call {
            print("real call \(ts) callNumber \(self.callNumber)")
        }
    }

}

