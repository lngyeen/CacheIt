//
//  AppDelegate.swift
//  LNSCache=
//
//  Created by nguyenlam on 6/5/20.
//  Copyright © 2020 nguyenlam. All rights reserved.
//

import UIKit

var movieCache = Cache<Int, Movie>()
var imageCache = Cache<String, UIImage>()

let cacheQueue = DispatchQueue(label: "fu.com.LNSCache-cacheIn-queue", qos: .background)
let saveCacheQueue = DispatchQueue(label: "fu.com.LNSCache-saveCache-queue", qos: .userInitiated, attributes: .concurrent)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print(NSHomeDirectory())

        // decode cache
        let folderURLs = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let fileURL = folderURLs[0].appendingPathComponent(Const.kMovieCacheFileName).appendingPathExtension("cache")

        do {
            movieCache = try JSONDecoder().decode(Cache<Int, Movie>.self, from: try Data(contentsOf: fileURL))
        } catch {
            print(error)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        // save cache
        saveCacheQueue.async {
            do {
                try movieCache.saveToDisk(withName: Const.kMovieCacheFileName)
                print("=== movieCache saved!")
            } catch {
                print("Fail to save movieCache to disk")
            }
        }

    }

}

