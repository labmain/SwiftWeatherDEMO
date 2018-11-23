//
//  ViewController.swift
//  SwiftWeatherDEMO
//
//  Created by 王顺 on 2018/11/18.
//  Copyright © 2018 labmain. All rights reserved.
//

import UIKit
import HandyJSON

class ViewController: UIViewController, UICollectionViewDataSource  {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var weatherImgV: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    // 风
    @IBOutlet weak var windImgV: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    // 紫外线
    @IBOutlet weak var uvImgV: UIImageView!
    @IBOutlet weak var uvLabel: UILabel!
    // 湿度
    @IBOutlet weak var dryingImgv: UIImageView!
    @IBOutlet weak var dryingLabel: UILabel!
    
    
    var weather : Weather! = nil
    var todayWeather : TodayWeather! = nil
    var dataArray : [Forecast]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flowLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width / 5, height: self.collectionView.frame.size.height)
        
        NetworkManager.weatherData(cityName: "北京") { (responseDict:Dictionary<String, AnyObject>) in
//            UserDefaults.standard.set(responseStr, forKey: "weatherStr")
            if let weather:Dictionary<String, AnyObject> = responseDict["today"] as? Dictionary<String, AnyObject> {
                self.weather = Weather.deserialize(from: weather)
            }
            if (self.weather != nil) {
                if let today:Dictionary<String, AnyObject> = responseDict["sk"] as? Dictionary<String, AnyObject> {
                    self.todayWeather = TodayWeather.deserialize(from: today)
                }
                
                self.updateUI()
                
                if let future:Dictionary<String, AnyObject> = responseDict["future"] as? Dictionary<String, AnyObject> {
                    let sortedArray = future.sorted(by: {$0.0 < $1.0}) // 根据 key 排序
                    var array:[AnyObject] = Array()
                    sortedArray.forEach({ (key, value) in
                        array.append(value)
                    })
                    if let dataArray = [Forecast].deserialize(from: array) as? [Forecast] {
                        self.weather.daily = dataArray
                        self.dataArray = dataArray
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    func updateUI() {
        self.weatherImgV.image = UIImage.init(named: self.checkWeatherImage(name: self.weather.weather ?? "")!)
        self.weatherLabel.text = self.todayWeather.temp
        self.cityNameLabel.text = self.weather.city
        
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateeString = formatter.string(from: nowDate)
        
        self.lastUpdateLabel.text = "\(dateeString) \(self.todayWeather.time ?? "") 发布"
        
        self.windLabel.text = self.todayWeather.wind_strength
        self.uvLabel.text = self.weather.uv_index
        self.dryingLabel.text = self.weather.dressing_index
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WSCollectionViewCell", for: indexPath) as! WSCollectionViewCell
        cell.weekLabel.text = self.dataArray?[indexPath.row].week
        if let image = self.checkWeatherImage(name: self.dataArray?[indexPath.row].weather ?? "") {
            cell.weatherImgV.image = UIImage.init(named: image)
        }
        cell.temperatureLabel.text = self.dataArray?[indexPath.row].temperature
        return cell
    }
    
    func checkWeatherImage(name: String) -> String? {
        switch name {
        case "晴转多云":
            return "cloudy"
        case "多云转晴":
            return "sun"
        case "晴":
            return "sun"
        case "阴":
            return "yin"
        case "雪":
            return "snow_s"
        case "雾":
            return "fog"
        case "阵雨":
            return "zhenyu"
        case "雷阵雨":
            return "leizhenyu"
        default:
            return "sun"
        }
    }
    
}

class WSCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var weekLabel: UILabel! //!< 星期一
    @IBOutlet weak var weatherImgV: UIImageView! //!< 天气图标
    @IBOutlet weak var temperatureLabel: UILabel! // 温度
    
}
