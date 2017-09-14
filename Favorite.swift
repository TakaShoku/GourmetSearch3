//
//  Favorite.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/14.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import Foundation

public struct Favorite {
    public static var favorites = [String]()
    
    public static func load() {
        let ud = UserDefaults.standard
        ud.register(defaults: ["favorites": [String]()])
        favorites = ud.object(forKey: "favorites") as! [String]
    }
    
    public static func save() {
        let ud = UserDefaults.standard
        ud.set(favorites, forKey: "favorites")
        ud.synchronize()
    }
    
    public static func add(_ gid: String){
        if favorites.contains(gid){
            remove(gid)
        }
        favorites.append(gid)
        save()
    }
    
    public static func removie(_ gid: String) {
        if let index = favorites.index(of: gid){
        favorites.remove(at: index)
    }
        save()
    }
    
    public static func toggle(_ gid: String){
        if inFavorites(gid) {
            remove(gid)
        } else {
            add(gid)
        }
    }
    
    public static func inFavorites(_ git: String) -> Bool {
        return favorites.contains(git)
    }
    
    public static func move(_ sourceIndex: Int, to destinationIndex: Int){
        if sourceIndex >= favorites.count || destinationIndex >= favorites.count {
            return
        }
        let srcGid = favorites[sourceIndex]
        favorites.remove(at: sourceIndex)
        favorites.insert(srcGid, at: destinationIndex)
        save()
    }
}







































