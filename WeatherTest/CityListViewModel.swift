import Foundation
import CoreLocation

protocol CityListDelegeate {
    func receivedCitiesWeathers(citiesWeathers: [WeatherResponse])
}

class CityListViewModel: NSObject, CLLocationManagerDelegate {
    
    var delegate: CityListDelegeate?
    let networkManager = NetworkManager()
    var citiesWeathers = [WeatherResponse]()
    var isDataWeatherDeleted = false
    var isLocationStatusEnabled = true
    let locationManager = CLLocationManager()
            
    override init() {
        super.init()
    
        locationManager.delegate = self
    }
    
    func checkCoreDataWeathersRequest() {
        locationManager.requestWhenInUseAuthorization()
        citiesWeathers = CoreDataHelper().retrieveDataWeather()
        if citiesWeathers.count > 0 {
            delegate?.receivedCitiesWeathers(citiesWeathers: citiesWeathers)
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            requestWeathersIfLocationEnabled()
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestWeathersIfLocationEnabled()
    }
    
    func requestCityWeather(cityName: String) {
        networkManager.weatherByCity(cityName: cityName, completion: { (weather, error) in
            if let error = error {
                print(error)
                return
            }
            guard let weather = weather else {
                return
            }
            if self.isDataWeatherDeleted == false {
                CoreDataHelper().deleteDataWeather()
                self.citiesWeathers = [WeatherResponse]()
                self.isDataWeatherDeleted = true
            }
            CoreDataHelper().storeData(weatherResponse: weather)
            self.citiesWeathers.append(weather)
            self.delegate?.receivedCitiesWeathers(citiesWeathers: self.citiesWeathers)
        })
    }
    
    func requestLocationWeather(lat: String?, lon: String?) {
        guard let lat = lat else {
            return
        }
        guard let lon = lon else {
            return
        }
        networkManager.weatherByLocation(lat: lat, lon: lon, completion: { (weather, error) in
            if let error = error {
                print(error)
                return
            }
            guard let weather = weather else {
                return
            }
            if self.isDataWeatherDeleted == false {
                CoreDataHelper().deleteDataWeather()
                self.citiesWeathers = [WeatherResponse]()
                self.isDataWeatherDeleted = true
            }
            CoreDataHelper().storeData(weatherResponse: weather)
            self.citiesWeathers.append(weather)
            self.delegate?.receivedCitiesWeathers(citiesWeathers: self.citiesWeathers)
        })
    }
    
    func requestCitiesWeathers() {
        for city in CityList.cityList {
            if city == StringConstant.CURRENT_LOCATION {
                requestLocationWeather(lat: locationManager.location?.coordinate.latitude.description, lon: locationManager.location?.coordinate.longitude.description)
            } else {
                requestCityWeather(cityName: city)
            }
        }
    }
    
    func requestWeathersIfLocationEnabled() {
        if isLocationStatusEnabled == true {
            requestCitiesWeathers()
            isLocationStatusEnabled = false
        }
    }
}
