//
//  Weather.swift
//  SwiftWeatherDEMO
//
//  Created by shun on 2018/11/22.
//  Copyright © 2018 labmain. All rights reserved.
//

import Foundation
import HandyJSON

/// 天气数据模型
class Weather: NSObject,HandyJSON {
    /// 今日温度 8℃~20℃
    var temperature: String?
    /// 今日天气 晴转霾
    var weather: String?
    /// 风 西南风微风
    var wind: String?
    /// 星期五
    var week: String?
    /// 城市
    var city: String?
    /// 日期
    var date_y: String?
    /// 穿衣指数
    var dressing_index: String?
    /// 穿衣指数
    var dressing_advice: String?
    /// 紫外线强度
    var uv_index: String?
    
    var wash_index: String?
    var travel_index: String?
    var exercise_index: String?
    /// 未来天气预报
    var daily: [Forecast]?
    
    required override init() {}
}

class TodayWeather: NSObject,HandyJSON {
    var temp: String?
    var wind_direction: String?
    var wind_strength: String?
    var humidity: String?
    var time: String?
    
     required override init() {}
}

/// 未来天气预报
class Forecast: NSObject,HandyJSON {
    var temperature: String?
    var weather: String?
    var wind: String?
    var week: String?
    var date: String?
    
    required override init() {}
}
