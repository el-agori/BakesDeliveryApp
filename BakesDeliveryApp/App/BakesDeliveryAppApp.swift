//
//  BakesDeliveryAppApp.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 18/12/2024.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()  // Initialize Firebase
        return true
    }

  
    // Forward remote notifications with fetch completion handler
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        // Handle your own notifications here
        completionHandler(.newData)
    }
}
@main
struct BakesDeliveryAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var show = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                if show {
                    ContentView()
                    
                }else{
                    SplashScreenView()
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                    withAnimation{
                        show = true
                        
                    }
                }
            }
        }
    }
}
