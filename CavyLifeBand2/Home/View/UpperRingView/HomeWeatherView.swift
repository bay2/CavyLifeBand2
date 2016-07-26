//
//  HomeWeatherView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions


class HomeWeatherView: UIView {

    /// 天气图片
    @IBOutlet weak var imgView: UIImageView!
    
    /// 温度
    @IBOutlet weak var temperature: UILabel!
    
    /// 空气
    @IBOutlet weak var airQuality: UILabel!
    
    /// 当前城市
    var city = "hangzou"
    
    override func awakeFromNib() {
        temperature.textColor = UIColor(named: .AColor)
        temperature.font = UIFont.mediumSystemFontOfSize(16.0)
        
        airQuality.textColor = UIColor(named: .AColor)
        airQuality.font = UIFont.mediumSystemFontOfSize(12.0)
        loadWeahDate()

    }
    

    /**
     加载天气视图
     */
    func loadWeatherView() {
       
        // 确定城市名字索引
        var cityResult = "hangzou"

        SCLocationManager.shareInterface.startUpdateLocationCity {
            cityResult = $0
            // 去掉市
            let index = cityResult.rangeOfString("市")
            if index != nil {
                
                cityResult.removeRange(index!)
                
            }
            
            // 转换拼音
            let str = CFStringCreateMutableCopy(nil, 0, cityResult)
            if CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false) {}
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {}
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {}
            self.city = String(str)
            
            // 删除中间的空格 hang zhou => hangzhou
            if self.city.contains(" ") {
                
                let spaceIndex = self.city.rangeOfString(" ")
                self.city.removeRange(spaceIndex!)
                
            }
            
            Log.info(self.city)

            self.loadWeahDate()
        }
        
    }
    
    /**
     加载天气数据
     */
    func loadWeahDate() {
        
        WeatherWebApi.shareApi.parseWeatherInfo(city) { weatherInfo in
            
            self.temperature.text = "\(weatherInfo.tmp!)°C"
            self.addAirCondition(weatherInfo.pm25!)
            self.addCondImage(weatherInfo.condition!)
            
        }
        
    }
    
    
    /**
     添加空气状态文本
     */
    func addAirCondition(pm25: Int) {
        
        var airCondition: String = ""
        
        if pm25 <= 35 {
            
            airCondition = L10n.HomeWeatherAirConditionBest.string
            
        } else if pm25 > 35 && pm25 <= 75 {
            
            airCondition = L10n.HomeWeatherAirConditionGood.string
            
        } else if pm25 > 75 && pm25 <= 115 {
            
            airCondition = L10n.HomeWeatherAirPollutionMild.string
            
        } else if pm25 > 115 && pm25 <= 150 {
            
            airCondition = L10n.HomeWeatherAirPollutionMiddle.string
            
        } else {
            
            airCondition = L10n.HomeWeatherAirPollutionBad.string
        }
        
        self.airQuality.text = "\(L10n.HomeWeatherAir.string)：\(airCondition)"

    }
    
    /**
     添加天气状况的图片
    */
    func addCondImage(cond: String) {
                
        let weatherNames = [L10n.HomeWeatherSun.string,
                            L10n.HomeWeatherCloudy.string,
                            L10n.HomeWeatherOvercast.string,
                            L10n.HomeWeatherRainOccasional.string,
                            L10n.HomeWeatherRainThundery.string,
                            L10n.HomeWeatherRainLight.string,
                            L10n.HomeWeatherRainMiddle.string,
                            L10n.HomeWeatherRainHeavy.string,
                            L10n.HomeWeatherSnowLight.string,
                            L10n.HomeWeatherSnowMiddle.string,
                            L10n.HomeWeatherSnowHeavy.string]
        
        let weatherImages = [UIImage(asset: .HomeWeatherSun),
                             UIImage(asset: .HomeWeatherCloudy),
                             UIImage(asset: .HomeWeatherOvercast),
                             UIImage(asset: .HomeWeatherRainOccasional),
                             UIImage(asset: .HomeWeatherRainThundery),
                             UIImage(asset: .HomeWeatherRainLight),
                             UIImage(asset: .HomeWeatherRain),
                             UIImage(asset: .HomeWeatherRainHeavy),
                             UIImage(asset: .HomeWeatherSnowLight),
                             UIImage(asset: .HomeWeatherSnow),
                             UIImage(asset: .HomeWeatherSnowHeavy)]
        
        
        for i in 0  ..< weatherNames.count {
                    
            if cond.contains(weatherNames[i]) {
                
                imgView.image = weatherImages[i]
            }
        }
        
    }
    
}


