//
//  AppDelegate.swift
//  Clouds
//
//  Created by Isaac Williams on 9/18/14.
//  Copyright (c) 2014 Isaac Williams. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.setStatusBarHidden(true, withAnimation: .None)
        return true
    }


}

