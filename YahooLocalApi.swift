//
//  YahooLocalApi.swift
//  GourmetSearch3
//
//  Created by 曽和寛貴 on 2017/09/09.
//  Copyright © 2017年 曽和寛貴. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


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
            var string = "\nGid: \(String(describing: gid))\n"
            string += "Name: \(String(describing: name))\n"
            string += "PhotoUrl: \(String(describing: photoUrl))\n"
            string += "Yomi: \(String(describing: yomi))\n"
            string += "Tel: \(String(describing: tel))\n"
            string += "Address: \(String(describing: address))\n"
            string += "Lat & Lon: \(String(describing: lat)), \(String(describing: lon))\n"
            string += "CatchCopy: \(String(describing: catchCopy))\n"
            string += "hasCoupon: \(hasCoupon)\n"
            string += "Staion: \(String(describing: station))\n"
            
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

public class YahooLocalSearch {
    let apiId = "dj00aiZpPUxKOTRCUjdjQkdDYSZzPWNvbnN1bWVyc2VjcmV0Jng9YTM-"
    let apiUrl = "http://search.olp.yahooapis.jp/OpenLocalPlatform/V1/localSearch"
    let perPage = 10
    public var shops = [Shop]()
    public var total = 0
    var condition: QueryCondition = QueryCondition() {
        didSet {
            shops = []
            total = 0
        }
    }
    
    public init(){}
    public init(condition: QueryCondition){self.condition = condition}
    
    public func loadDate(reset: Bool = false) {
        if reset {
            shops = []
            total = 0
        }
        
        var params = condition.queryParams
        
        params["appid"] = apiId
        params["output"] = "json"
        params["start"] = String(shops.count + 1)
        params["results"] = String(perPage)
        
        _ = Alamofire.request(apiUrl, method: .get, parameters: params).response {
            
            response in
            var json = JSON.null;
            if response.error == nil && response.data != nil {
                json = SwiftyJSON.JSON(data: response.data!)
            }
            
            if response.error != nil {
                return
            }
            
            for (_, item) in json["Feature"] {
                
                var shop = Shop()
                
                shop.gid = item["Gid"].string
                shop.name = item["Name"].string? .replacingOccurrences(of: "&#39;", with: "'")
                shop.yomi = item["Property"]["Yomi"].string
                shop.tel = item["Property"]["Tell"].string
                shop.address = item["Property"]["Address"].string
                
                if  let geometry = item["Geometry"]["Coordinates"].string {
                    let components = geometry.components(separatedBy: ",")
                    shop.lat = (components[1] as NSString).doubleValue
                    shop.lon = (components[0] as NSString).doubleValue
                }
                shop.catchCopy = item["Property"]["CatchCopy"].string
                shop.photoUrl = item["Property"]["LeadImage"].string

                if item["Property"]["CouponFlag"].string == "true" {
                    shop.hasCoupon = true
                }
                
                if let stations = item["Property"]["Station"].array {
                    var line = ""
                    if let lineString = stations[0]["Railway"].string {
                        let lines = lineString.components(separatedBy: "/")
                        line = lines[0]
                    }
                    if let station = stations[0]["Name"].string {
                    shop.station = "\(line) \(station)"
                    } else {
                        shop.station = "\(line)"
                    }
                }
                self.shops.append(shop)
                
            }
            
            if let total = json["resultInfo"]["Total"].int {
                self.total = total
            } else {
                self.total = 0
            }
        }
        
    }
}
