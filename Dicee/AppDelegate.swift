//
//  AppDelegate.swift
//  Dicee
//
//  Created by Eduardo Perez on 5/14/19.
//  Copyright © 2019 Eduardo Perez. All rights reserved.
//

import UIKit
import AppsFlyerLib
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //call AF ID before SDK initialize (client test)
        print(AppsFlyerTracker.shared().getAppsFlyerUID())
        
        
//        AppsFlyerTracker.shared().isStopTracking = true
        
        // Override point for customization after application launch.
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "DEV_KEY_HERE";
        AppsFlyerTracker.shared().appleAppID = "NUMERICAL_APP_ID_HERE"
        
        AppsFlyerTracker.shared().delegate = self
        
        /*set to true to see SDK debug logs */
        AppsFlyerTracker.shared().isDebug = true
        
        let CustomDataMap: [AnyHashable: Any] = [
            "Heap User ID" : "value_of_param_1"
        ]
        
        AppsFlyerTracker.shared().customData = CustomDataMap
        
        
        /*Uninstall tracking code */
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//        application.registerForRemoteNotifications()
        
        
        //user invites
        AppsFlyerTracker.shared()?.appInviteOneLinkID = "I1hb"
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
 
        AppsFlyerTracker.shared().trackAppLaunch()
        
        //other code here
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    /*------------------------------------------------------------------*/
    //deferred deeplink stuff
    func onConversionDataReceived(_ installData: [AnyHashable : Any]!) {
        NSLog("FESS :: onConversionDataReceived is called")
        print("FESS :: onConversionDataReceived is called")
        //do stuff here with the conversion data
        guard let first_launch_flag = installData["is_first_launch"] as? Int else {
            return
        }
        
        guard let status = installData["af_status"] as? String else {
            return
        }
        
        if(first_launch_flag == 1) {
            if(status == "Non-organic") {
                if let media_source = installData["media_source"] , let campaign = installData["campaign"]{
                    print("This is a Non-Organic install. Media source: \(media_source) Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
        } else {
            print("Not First Launch")
        }
    }
    
    func onConversionDataRequestFailure(_ error: Error!) {
        //do stuff if it fails
        if let err = error{
            print(err)
        }
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]!) {
        NSLog("FESS :: onAppOpenAttribution is called")
        print("FESS :: onAppOpenAttribution is called")
        //handle deep link data
        if let data = attributionData{
            NSLog("%@",data)
        }
    }

    func onAppOpenAttributionFailure(_ error: Error!) {
        //return error from deep link
        if let err = error{
            print(err)
        }
    }
    
    //swift 4.2 and above
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        return true
    }

      // Reports app open from deep link from apps which do not support Universal Links (Twitter) and for iOS8 and below
      func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
      }

    
    // Reports app open from deep link for iOS 10 or later
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        
        return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
    }

}

