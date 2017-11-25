//
//  InterfaceController.swift
//  FOCUS wk Extension
//
//  Created by Storm Lim on 25/9/16.
//  Copyright © 2016 JLim. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var timer = NSTimer()
    var hr: Double = 0
    var min: Double = 0
    var sec: Double = 0

    let session = WCSession.defaultSession()
    
    @IBOutlet var counter: WKInterfaceActivityRing!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if(WCSession.isSupported()){
            session.delegate = self
            session.activateSession()
        }
        
        let timer = HKActivitySummary()
        
        timer.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: hr)
        timer.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: 24)
        
        timer.appleExerciseTime = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: min)
        timer.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: 60)
        
        timer.appleStandHours = HKQuantity(unit: HKUnit.countUnit(), doubleValue: sec)
        timer.appleStandHoursGoal = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 600)
        
        counter.setActivitySummary(timer, animated: true)
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]){
        let started : String = applicationContext["started"] as! String
        if started == "1" {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(InterfaceController.track), userInfo: nil, repeats: true)
            })
        } else {
            timer.invalidate()
        }
    }
    
    func track() {
        sec += 1
        if sec == 60 {
            sec = 0
            min += 1
        }
        if min == 60 {
            min = 0
            hr += 1
        }
        
        let timer = HKActivitySummary()
        
        timer.activeEnergyBurned = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: sec)
        timer.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: 60)
        
        timer.appleExerciseTime = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: min)
        timer.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: 60)
        
        timer.appleStandHours = HKQuantity(unit: HKUnit.countUnit(), doubleValue: hr)
        timer.appleStandHoursGoal = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 24)
        
        counter.setActivitySummary(timer, animated: true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
