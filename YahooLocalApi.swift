//
//  YahooLocalApi.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/09.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import Foundation


public struct Shop: CustomStringConvertible {
    public var gid: String? = nil
    public var name: String? = nil
    public var photoUrl: String? = nil
    public var yomi: String? = nil
    public var tel: String? = nil
    public var address: String? = nil
    public var lat: Double? = nil
    public var lon: Double? = nil
    public var catchCopy: String? = nil
    public var hasCoupon = false
    public var station: String? = nil

    public var description: String {
        get {
            var string = "\nGid: \(gid)\n"
            string += "Name: \(name)\n"
            string += "PhotoUrl: \(photoUrl)\n"
            string += "Yomi: \(yomi)\n"
            string += "Tel: \(tel)\n"
            string += "Address: \(address)\n"
            string += "Lat & Lon: \(lat), \(lon)\n"
            string += "CatchCopy: \(catchCopy)\n"
            string += "hasCoupon: \(hasCoupon)\n"
            string += "Staion: \(station)\n"
            
            return string
        }
        
      }
}

public struct QueryCondition {
    
    public var query: String? = nil
    public var gid : String? = nil
    
    public enum Sort: String {
        case score = "score"
        case geo = "geo"
    }
    
    public var sort: Sort = .score
    public var lat: Double? = nil
    public var lon: Double? = nil
    public var dist: Double? = nil
    
    public var queryParams: [String: String] {
        get {
            
            var params = [String: String]()
            
            if let unwrapped = query {
                params["query"] = unwrapped
            }
            
            if let unwrapped = gid {
                params["gid"] = unwrapped
            }
            
            switch sort {
            case .score:
                params["sort"] = "score"
            case .geo:
                params["sort"] = "geo"
            }
            
            if let unwrapped = lat {
                params["lat"] =  "\(unwrapped)"
                
            }
            if let unwrapped = lon {
                params["lon"] =  "\(unwrapped)"
            }
                if let unwrapped = dist {
                    params["dist"] = "\(unwrapped)"
            }
        params["device"] = "mobile"
        params["group"] = "gid"
        params["image"] = "true"
        params["gc"] = "01"
            
        return params
        
        }
}
}
