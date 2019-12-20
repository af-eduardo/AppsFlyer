//
//  ViewController.swift
//  Dicee
//
//  Created by Eduardo Perez on 5/14/19.
//  Copyright © 2019 Eduardo Perez. All rights reserved.
//

import UIKit
import AppsFlyerLib

class ViewController: UIViewController {
    
    //properties about UILabel
    @IBOutlet weak var myLabel: UILabel!
    
    var randomDiceIndex1 : Int = 0
    var randomDiceIndex2 : Int = 0
    
    let diceArray = ["dice1", "dice2", "dice3", "dice4", "dice5", "dice6"]
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
        updateDiceImages()
    }

    @IBAction func rollButtonPressed(_ sender: UIButton) {
        
        AppsFlyerShareInviteHelper.generateInviteUrl(linkGenerator:
         {(_ generator: AppsFlyerLinkGenerator) -> AppsFlyerLinkGenerator in
          generator.setChannel("myTestChannel")
          generator.setReferrerName("Eduardo")
          generator.addParameterValue("2.5", forKey: "af_cost_value")
          return generator },
        completionHandler: {(_ url: URL?) -> Void in
            // write logic to let the user share the invite link
            self.myLabel.text = url?.absoluteString
            print(url?.absoluteString)
        })
        
        updateDiceImages()
        
        AppsFlyerTracker.shared().trackEvent(AFEventPurchase, withValues: [AFEventParamRevenue: "1200", AFEventParamContent: "shoes", AFEventParamContentId: "123"]);

    }
    
    func updateDiceImages() {
        randomDiceIndex1 = Int(arc4random_uniform(6))
        randomDiceIndex2 = Int(arc4random_uniform(6))
        
        diceImageView1.image = UIImage(named: diceArray[randomDiceIndex1])
        diceImageView2.image = UIImage(named: diceArray[randomDiceIndex2])

    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateDiceImages()
        
        AppsFlyerTracker.shared().trackEvent("I Shook My Phone", withValues: [AFEventParamRevenue: "123", "af_currency": "EUR", "what happened": "shook", "IDFV": UIDevice.current.identifierForVendor!.uuidString]);
 
        AppsFlyerTracker.shared().trackEvent("test event", withValues: ["third value":"123","first value":"1200","second value":"shoes"]);
     }
    
}

