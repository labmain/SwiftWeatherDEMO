//
//  NetworkManager.swift
//  SwiftWeatherDEMO
//
//  Created by shun on 2018/11/22.
//  Copyright © 2018 labmain. All rights reserved.
//

import Foundation
import HandyJSON
import Alamofire

typealias SuccessStringClosure = (_ result: Dictionary<String, AnyObject>) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    
    private let appCode = "APPCODE 691a8c4d415449ffb69b1a7ac2a4000d"
    private let url = "http://weatherapi.market.alicloudapi.com/weather/TodayTemperatureByCity"

    class func weatherData(cityName: String, success: @escaping SuccessStringClosure) {
        self.shared.getWeaterData(cityName: cityName, SuccessStringClosure: success)
    }
    
    private func getWeaterData(cityName: String, SuccessStringClosure:@escaping SuccessStringClosure) {
        Alamofire.request(url, method: .post, parameters: ["cityName" : cityName], headers: ["Authorization" : appCode]).responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                if let items = response.result.value as? Dictionary<String, AnyObject> {
                    let result = items["result"] as! [String: AnyObject]
                    SuccessStringClosure(result)
                }
            case false:
                print(response.result.error ?? "error")
            }
        }
        
    }
}
