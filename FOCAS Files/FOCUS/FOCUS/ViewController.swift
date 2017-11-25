//
//  ViewController.swift
//  FOCUS
//
//  Created by Storm Lim on 23/9/16.
//  Copyright © 2016 JLim. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var connection: UILabel!
    @IBOutlet weak var watchIcon: UIImageView!
    
    var i = 0
    
    var started = "0" //0 false - 1 true
    var quotes = ["If Not Us, Who?", "If Not now, when?", "You must do\nthe thing you\nthink you\ncannot do.", "The best way out is always through", "I can\nand\ni will", "You are stronger than you think", "Never give up", "work\nhard\ndream\nbig", "Hope is stronger than fear", "Be happy\nbe bright\nbe you", "worry less\nsmile more", "life is a one time offer, use it well", "Tonight, I dream.\nTomorrow I do", "Losers quit when they fail", "Winners fail until they succeed", "The future starts today\nnot tomorrow", "Doubts kill more dreams\nthan failure ever will", "Success is the sum of small efforts repeated day in day out", "Dreams don't work unless you do", "I'll find strength in pain", "Mistakes are proof you're trying", "The greater your storm the brighter your rainbow", "life begins at the end of your comfort zone", "be you\nand\nstay you", "Don't just fly,\nSoar", "Never\nstop\ndreaming", "Dream big", "Only those who attempt the absurd\nwill achieve the impossible", "all things are possible\n\nbelieve", "Our thoughts\ndetermine\nour reality", "Be the change you wish to see in the world", "Aspire\nto\ninspire\nbefore we\nexpire", "A jug fills drop by drop", "Difficult roads often lead to beautiful destinations", "Hope is the heartbeat of the soul", "Wherever you go,\ngo with all your heart", "Pain makes people change", "Doubt your\nDoubts\nbefore you doubt yourself", "nothing great ever came that easy", "It is\npossible", "What ever you\ndecide to do,\nmake sure it\nmakes you happy", "Turn your wounds into wisdom", "Never\nregret\nanything", "be the best version of you", "Do things everyday that scares you", "Never let go of your dreams", "We become what we think about", "Live what you love", "The best is yet to come", "Success is the best revenge", "make a wish\ntake a chance\nmake a change", "Dream big\nand\ndare to fail", "You woke up,\nYou're a miracle", "all you need is love", "What you are looking for is not out there\nit's in you", "It is better to fail aiming high\nthan succeed aiming low", "don't count the days\nmake the days count", "Don't regret the pass\nlearn from it", "You\nOnly\nLive\nOnce", "You can do anything", "Life doesn't get easier\nyou just get stronger", "It just takes some time", "Stars can't shine without darkness", "I never lose.\nI either win or\nI learn", "If you do what you alwaus did\nyou will get what you always get", "wake up with determination.\ngo to be with satisfaction", "enjoy\nevery\nsandwich", "The obstacle is the path", "every moment matters", "And now i'll do\nwhat's best for me", "enjoy the little things", "we rise by lifting others", "believe you can\nand\nyou're halfway there", "be a rainbow in someone else's cloud.", "Find yourself,\nand be that", "you can make a difference\nif you try", "In helping others we help ourselves", "Having hope will give you courage", "What's done\nis done.", "If you never try\nyou'll never know", "When nothing goes right...\n\ngo left", "Stay\nStrong", "I'm batman", "Life is too short\nto wait", "I will win\nnot immediately\nbut definitely", "Enjoy every moment as it comes.", "die with memories\nnot dreams", "and now i'll do what's best for me", "Hold on,\npain ends", "You can only do your best,\nand if they can't appreciate that, it's their problem.", "It goes on", "To be old and wise,\nyou must first have to be young and stupid", "Don't\nstop\nuntil\nyou're\nproud", "Keep mobing forward", "Somedays you just have to create your own sunshine", "You are\nyour only\nlimit", "nothing worth comes easy", "Make yourself a priority", "Life is tough,\nbut so are you.", "Inhale the future,\nexhale the pass."]
    
    var brightness = CGFloat()
    
    var session: WCSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(quotes.count)
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session?.delegate = self
            session?.activateSession()
        }
        
        if session?.paired == true {
            connection.text = "Connected"
        } else {
            connection.text = "Not Connected"
        }
        self.watchIcon.layer.cornerRadius = self.watchIcon.frame.width/2
        self.watchIcon.clipsToBounds = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.watch))
        watchIcon.userInteractionEnabled = true
        watchIcon.addGestureRecognizer(tap)
    }
    
    func watch() {
        label.text = "Connect to your\nApple Watch\n(If you own one)"
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("scrub")
    }

    func rotated() {
        if UIDevice.currentDevice().orientation.rawValue == 2 || UIDevice.currentDevice().orientation.rawValue == 6 {
            started = "1"
            
            view.backgroundColor = UIColor.blackColor()
            watchIcon.alpha = 0
            brightness = UIScreen.mainScreen().brightness
            UIScreen.mainScreen().brightness = 0
        } else {
            view.backgroundColor = UIColor.whiteColor()
            watchIcon.alpha = 1
            if started == "1" {
                label.text = quotes[Int(arc4random_uniform(UInt32(quotes.count)))]
                started = "0"
                UIScreen.mainScreen().brightness = brightness
                i += 1
            }
        }
        if let validSession = session {
            let iPhoneAppContext = ["started": started]
            do {
                try validSession.updateApplicationContext(iPhoneAppContext)
                print(iPhoneAppContext)
            } catch {
                print("Something went wrong")
            }
            print("hi")
        }
    }
    
}

