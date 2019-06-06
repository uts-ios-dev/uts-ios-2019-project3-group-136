

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Kingfisher


class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    let weather = Weather()
    let appid = "e72ca729af228beabd5d20e3b7749713"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var curLat: CGFloat = 0
    var curLon: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
    
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        print(lat,lon)
       
        let paras = ["lat":"\(lat)","lon":"\(lon)","appid":appid]
        getWeather(paras: paras)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCity"{
            
            let vc = segue.destination as! SelectCityController
            vc.currentCity = weather.city
            
            vc.delegate = self
        }
        if segue.identifier == "detail" {
            let vc = segue.destination as! WeatherDetailController
            vc.cityName = weather.city
            vc.lat = self.curLat
            vc.lon = self.curLon
        }
    }
    
    @IBAction func close(segue:UIStoryboardSegue){
        //
    }
}




extension ViewController:CLLocationManagerDelegate,SelectCityDelegate{
    
    func didChangeCity(city: String) {
        let paras = ["q":city,"appid":appid]
        getWeather(paras: paras)
    }
    
    

    func getWeather(paras:[String:String]){
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather",parameters: paras).responseJSON { response in
   
            if let json = response.result.value {
                let weather = JSON(json)
                
                self.createWeather(weatherJSON: weather)
                
                self.updateUI()
            }
        }
    }
    
 
    func createWeather(weatherJSON:JSON){
        weather.city = weatherJSON["name"].stringValue
        weather.temp = Int(round(weatherJSON["main","temp"].doubleValue-273.15))
        weather.condition = weatherJSON["weather",0,"id"].intValue
        self.curLat = CGFloat(weatherJSON["coord","lat"].floatValue)
        self.curLon = CGFloat(weatherJSON["coord","lon"].floatValue)
    }
    
 
    func updateUI(){
        cityLabel.text = weather.city
        tempLabel.text = "\(weather.temp)˚"
        imageView.image = UIImage(named: weather.icon)
 
        let weatherKey = weather.icon.trimmingCharacters(in: CharacterSet.decimalDigits)
        updateCoverImage(weather.city + " " + weatherKey)
    }
    
    

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "获取位置失败"
    }
    
    func updateCoverImage(_ search: String) {
        print( search)
        Alamofire.request("http://www.ikefou.com/search/search",parameters: ["k": search]).responseJSON { response in

            if let json = response.result.value {
                let weather = JSON(json)
                print(weather)
                if weather["code"] == "1" {
                    let url = URL(string: weather["data"].stringValue)
                    self.coverImageView.kf.setImage(with: url)
                }
                
            }
        }
    }
    
}
