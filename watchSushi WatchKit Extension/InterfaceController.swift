//
//  InterfaceController.swift
//  watchSushi WatchKit Extension
//
//  Created by Vivek Batra on 2019-10-30.
//  Copyright © 2019 student. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate
{
    @IBOutlet weak var timerUpdateLabel: WKInterfaceLabel!
    @IBOutlet weak var powerUpButton: WKInterfaceButton!
    var increaseTimer:String = ""
    var score : Int = 0
    var palyerName : String = ""
    
    var timeCounter = 0
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
    {
    }
    
    func session(_ session: WCSession, didReceiveMessage time: [String : Any])
    {
        if self.timeCounter == 3
        {
            self.timeCounter = 0
        }
        else
        {
            self.timeCounter += 1
        }
        
        let powerUp = time["powerUp"] as! String
        let time = time["time"] as! Int
        if (time == 15 || time ==  10 || time == 5 || time == 0)
        {
            self.timerUpdateLabel.setHidden(false)
            self.timerUpdateLabel.setText("Time left: \(time)")
        }
        else
        {
            self.timerUpdateLabel.setHidden(true)
        }
        if time == 0
        {
            presentTextInputController(withSuggestions: [""], allowedInputMode: .plain)
            {
                (results) in
                if (results != nil && results!.count > 0)
                {
                    let userResponse = results?.first as? String
                    self.palyerName = userResponse!
                    let message = ["tapped":"left", "increaseTimer":"false", "pause":"false", "name":"\(self.palyerName)"] as [String : Any]
                    WCSession.default.sendMessage(message, replyHandler:nil)
                }
            }

        }
        if (powerUp == "true")
        {
            self.powerUpButton.setHidden(false)
            self.timeCounter += 1

        }
        else if (powerUp == "false" || self.timeCounter == 0)
        {
            self.powerUpButton.setHidden(true)
        }
    }

    override func awake(withContext context: Any?)
    {
        super.awake(withContext: context)
    }
    
    override func willActivate()
    {
        super.willActivate()
        
        if WCSession.isSupported()
        {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        self.timerUpdateLabel.setHidden(true)
        self.powerUpButton.setHidden(true)
    }
    
    override func didDeactivate()
    {
        super.didDeactivate()
    }

    @IBAction func tappedRight()
    {
        if (WCSession.default.isReachable == true)
        {
            let message = ["tapped":"right", "increaseTimer":"false", "pause":"false", "name":"false"] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler:nil)
            print("move right")
        }
        else
        {
            print("Message was not sent to Phone")
        }
    }
    @IBAction func tappedLeft()
    {
        if (WCSession.default.isReachable == true)
        {
            let message = ["tapped":"left", "increaseTimer":"false", "pause":"false", "name":"false"] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler:nil)
            print("Move left")
        }
        else
        {
            print("Message was not sent to Phone")
        }
    }
    
    
    @IBAction func increaseTimePressed()
    {
        if (WCSession.default.isReachable == true)
        {
            let message = ["tapped":"left", "increaseTimer":"true", "pause":"false", "name":"false"] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler:nil)
            print("increaseTimer sent")
        }
        else
        {
            print("Message was not sent to Phone")
        }
    }
    
    @IBAction func pauseButtonPressed()
    {
        if (WCSession.default.isReachable == true)
        {
            let message = ["tapped":"", "increaseTimer":"false", "pause":"true", "name":"false"] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler:nil)
            print("Pause sent")
        }
        else
        {
            print("Message was not sent to Phone")
        }
    }
    
}
