//
//  AppDelegate.swift
//  SuspendTime
//
//  Created by jekun on 2022/2/23.
//

import UIKit
import AVKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window: UIWindow = UIWindow.init(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window.makeKeyAndVisible()
        self.window.rootViewController = ViewController()
        
        //需要设置App 的AVAudioSession的Category为playback模式
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback)
            } catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
        }
        return true
    }


}

