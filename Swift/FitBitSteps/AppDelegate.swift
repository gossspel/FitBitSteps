//
//  AppDelegate.swift
//  FitBit Steps
//
//  Created by Daniel Hsu on 7/18/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let VC = FitBitClientVC(nibName: nil, bundle: nil)
        VC.view.backgroundColor = UIColor.white
        window?.rootViewController = VC
        window?.makeKeyAndVisible()
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
        guard let sureVC = window?.rootViewController as? FitBitClientVC, let sureUserId = fitbitUserId else {
            return
        }
        
        sureVC.VM.getDESCNewSteps(sureUserId)
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		if url.host == "oauth-callback" {
			// OAuth explicit grant callback uses "#" instead of "?" in query string params so we need to replace it before we can properly parse the params
			let urlString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
			guard let url = URL(string: urlString) else {
			    DispatchQueue.main.async {
			        let alert = UIAlertController(title: "Whoops!", message: "There was an issue with your FitBit authentication. Please try again.", preferredStyle: .alert)
			        alert.show(self.window!.rootViewController!, sender: nil)
			    }
			    return false
			}

			fitbitAccessToken = url.queryStringValueOf(queryStringName: "access_token")
			fitbitUserId = url.queryStringValueOf(queryStringName: "user_id")
            fitbitTokenExpiresIn = Int(url.queryStringValueOf(queryStringName: "expires_in")!)!
            
            if let sureUserId = fitbitUserId, let sureVC = window?.rootViewController as? FitBitClientVC {
                sureVC.VM.getDESCNewSteps(sureUserId)
            }
		}
		return true
	}
}
