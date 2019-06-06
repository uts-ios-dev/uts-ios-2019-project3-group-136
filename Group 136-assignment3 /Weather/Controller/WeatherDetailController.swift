

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class WeatherDetailController: UIViewController {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperature1Label: UILabel!
    
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var weather2Label: UILabel!
    @IBOutlet weak var temperature2Label: UILabel!
    
    @IBOutlet weak var date3Label: UILabel!
    @IBOutlet weak var weather3Label: UILabel!
    @IBOutlet weak var temperature3Label: UILabel!
    
    @IBOutlet weak var uvLabel: UILabel!

    let appid = "e72ca729af228beabd5d20e3b7749713"
    
    var cityName = ""
    var lat: CGFloat = 0
    var lon: CGFloat = 0
    var today: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
//        getWeatherDetail()
        getSeven()
        getUV()
    }
    

    func getWeatherDetail() {
        if self.cityName.isEmpty {
            return
        }
        let appcode = "e07f7e4f64454f7885f9021309f3b74d";
        let host = "http://weather-ali.juheapi.com"
        let path = "/weather/index"
        let querys = "?cityname="+self.cityName+"&dtype=json&format=2";
        let url = host+path+querys
        Alamofire.request(url ,parameters: nil, headers: ["Authorization": "APPCODE "+appcode]).responseJSON { response in
            if let json = response.result.value {
                let weather = JSON(json)
                print(weather)
                if weather["resultcode"] == 200 {
                    self.cityLabel.text = self.cityName
                    self.temperature1Label.text = weather["result"]["today"]["temperature"].stringValue
                    self.uvLabel.text = weather["result"]["today"]["uv_index"].stringValue
                    
                    self.date2Label.text = weather["result"]["future"].arrayValue[0]["week"].stringValue
                    self.weather2Label.text = weather["result"]["future"].arrayValue[0]["weather"].stringValue
                    self.temperature2Label.text = weather["result"]["future"].arrayValue[0]["temperature"].stringValue
                    
                    self.date3Label.text = weather["result"]["future"].arrayValue[1]["week"].stringValue
                    self.weather3Label.text = weather["result"]["future"].arrayValue[1]["weather"].stringValue
                    self.temperature3Label.text = weather["result"]["future"].arrayValue[1]["temperature"].stringValue
                }
                
            }
        }
    }
    

    func getSeven() {
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast/daily",parameters: ["appid": appid, "lat": self.lat, "lon": self.lon, "units": "metric"]).responseJSON { response in

            if let json = response.result.value {
                let js = JSON(json)
                self.cityLabel.text = self.cityName
                let today = js["list", 0]
                self.temperature1Label.text = today["temp", "min"].stringValue + "°C ~ " + today["temp", "max"].stringValue + "°C"
                
                let day2 = js["list", 1]
                self.temperature2Label.text = day2["temp", "min"].stringValue + "°C ~ " + day2["temp", "max"].stringValue + "°C"
                self.date2Label.text = self.dateString(stamp: day2["dt"].stringValue)
                self.weather2Label.text = day2["weather",0, "main"].stringValue
                
                let day3 = js["list", 2]
                self.temperature3Label.text = day3["temp", "min"].stringValue + "°C ~ " + day3["temp", "max"].stringValue + "°C"
                self.date3Label.text = self.dateString(stamp: day3["dt"].stringValue)
                self.weather3Label.text = day3["weather",0, "main"].stringValue
            }
        }
    }
    

    func getUV() {
        Alamofire.request("https://api.openweathermap.org/data/2.5/uvi/forecast",parameters: ["appid": appid, "lat": self.lat, "lon": self.lon]).responseJSON { response in
    
            if let json = response.result.value {
                let js = JSON(json)
                self.uvLabel.text = "UV: " + js[0,"value"].stringValue
            }
        }
    }
    
    func dateString(stamp: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(stamp)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" 
        return dateFormatter.string(from: date)
    }
}
