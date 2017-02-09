//
//  Throttler.swift
//  Throttler
//
//  Created by Sergey Yuryev on 02/02/2017.
//  Copyright © 2017 syuryev. All rights reserved.
//

import Foundation

class Throttler: NSObject {
    
    /// work queue
    var queue: DispatchQueue = DispatchQueue.global(qos: .background)
    
    /// work item
    var item: DispatchWorkItem?
    
    
    var previousMs: Double = 0
    var interval: Int = 3
    
    
    init(interval: Int) {
        super.init()
        self.interval = interval
    }
    
    func call(block: @escaping () -> ()) {

        let diff = Date.nowTs() - self.previousMs
        let i: Double = Double(self.interval) * 1000
        
        if self.previousMs == 0 {
            self.item = DispatchWorkItem {
                self.previousMs = Date.nowTs()
                block()
            }
            if let item = self.item {
                self.queue.asyncAfter(deadline: .now() + .seconds(0), execute: item)
            }
        }
        else if (diff > i) {
            if let item = self.item {
                item.cancel()
                self.item = nil
            }
            self.item = DispatchWorkItem {
                self.previousMs = Date.nowTs()
                block()
            }
            if let item = self.item {
                self.queue.asyncAfter(deadline: .now() + .seconds(0), execute: item)
            }
        }
        else {
            if let item = self.item {
                item.cancel()
                self.item = nil
            }
            self.item = DispatchWorkItem {
                self.previousMs = Date.nowTs()
                block()
            }
            if let item = self.item {
                self.queue.asyncAfter(deadline: .now() + .seconds(self.interval), execute: item)
            }
        }
    }
    
    
}

extension Date {
    static func nowTs() -> Double {
        return Date().timeIntervalSince1970 * 1000
    }
}
