//
//  AppDelegate.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/6/8.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // navigation bar
        UINavigationBar.appearance()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1.0, green: 0.5, blue: 0.67, alpha: 0.3)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // status bar
        application.statusBarStyle = .LightContent
        
        
        // facebook delegate
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // auto login
        login()
        
        
        
        //添加icon 3d Touch
        let firstItemIcon:UIApplicationShortcutIcon = UIApplicationShortcutIcon(type: .Compose)
        let firstItem = UIMutableApplicationShortcutItem(type: "1", localizedTitle: "Post", localizedSubtitle: nil, icon: firstItemIcon, userInfo: nil)
        
//        let firstItemIcon1:UIApplicationShortcutIcon = UIApplicationShortcutIcon(type: .Search)
//        let firstItem1 = UIMutableApplicationShortcutItem(type: "2", localizedTitle: "Search", localizedSubtitle: nil, icon: firstItemIcon1, userInfo: nil)
        
        let firstItemIcon2:UIApplicationShortcutIcon = UIApplicationShortcutIcon(type: .Home)
        let firstItem2 = UIMutableApplicationShortcutItem(type: "3", localizedTitle: "Home", localizedSubtitle: nil, icon: firstItemIcon2, userInfo: nil)
        
        let qrcodeIcon:UIApplicationShortcutIcon = UIApplicationShortcutIcon(templateImageName: "qrcode.png")
        let qrcode = UIMutableApplicationShortcutItem(type: "4", localizedTitle: "Show Qrcode", localizedSubtitle: nil, icon: qrcodeIcon, userInfo: nil)

        let scanIcon:UIApplicationShortcutIcon = UIApplicationShortcutIcon(templateImageName: "scanner.png")
        let scanner = UIMutableApplicationShortcutItem(type: "5", localizedTitle: "Scan Qrcode", localizedSubtitle: nil, icon: scanIcon, userInfo: nil)
        
        
        application.shortcutItems = [firstItem, /*firstItem1,*/ firstItem2,qrcode, scanner]
        
        return true
    }
    
    
    
    /**
     3D Segue
     
     - parameter application:       application
     - parameter shortcutItem:      item
     - parameter completionHandler: handler
     */
    
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var handled = false
        
        if shortcutItem.type == "1" { //貼文
            let storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            myTabBar.selectedIndex = 2
            window?.rootViewController = myTabBar
            handled = true
            
        }
        
        if shortcutItem.type == "2" { //搜尋
            let storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            myTabBar.selectedIndex = 1
            window?.rootViewController = myTabBar
            handled = true
            
            
        }
        
        if shortcutItem.type == "3" { //Home
            let storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            myTabBar.selectedIndex = 4
            window?.rootViewController = myTabBar
            handled = true
        }
        
        if shortcutItem.type == "4" { //show
            
            // instance tabbarController.seledcted 4
            let storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            myTabBar.selectedIndex = 4
            window?.rootViewController = myTabBar
            
            // present scanner
            let scannerVC = storyboard.instantiateViewControllerWithIdentifier("GenVC") as! GenVC
            let navigationController = UINavigationController(rootViewController: scannerVC)
            myTabBar.presentViewController(navigationController, animated: true, completion: nil)
            
            handled = true
        }
        
        if shortcutItem.type == "5" { //scanne
            
            // instance tabbarController.seledcted 4
            let storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            myTabBar.selectedIndex = 4
            window?.rootViewController = myTabBar
            
            // present scanner
            let scannerVC = storyboard.instantiateViewControllerWithIdentifier("ScanVC") as! ScanVC
            let navigationController = UINavigationController(rootViewController: scannerVC)
            myTabBar.presentViewController(navigationController, animated: true, completion: nil)
            
            handled = true
        }
        
        return handled
    }
    
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.superlevin.mike840609.babySample" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("babySample", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - CUSTOMER FUNCTION
    
    func login(){
        
        // remember AccessToken login
        let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN)
        print("Auto login \n\(AccessToken)\n")
        
        // if logged in
        if AccessToken != nil {
            
            let storyboard:UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            window?.rootViewController = myTabBar
            
        }
        
    }
    
    //    func logout() {
    //
    //        NSUserDefaults.standardUserDefaults().removeObjectForKey(ACCESS_TOKEN)
    //        NSUserDefaults.standardUserDefaults().synchronize()
    //
    //        let loginVC = LoginController()
    //        let rootNavigationViewController = UINavigationController(rootViewController: loginVC)
    //
    //        self.window!.rootViewController = rootNavigationViewController
    //        
    //    }
    
    
    
}

