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
        requestWeathersIfLocationEnabled()
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
            self.requestWeatherLogic(weather: weather, cityName: cityName)
        })
    }
    
    func requestLocationWeather(lat: String?, lon: String?, cityName: String) {
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
            self.requestWeatherLogic(weather: weather, cityName: cityName)
        })
    }
    
    func requestWeatherLogic(weather: WeatherResponse, cityName: String) {
        var weatherValue = weather
        if isDataWeatherDeleted == false {
            CoreDataHelper().deleteDataWeather()
            citiesWeathers = [WeatherResponse]()
            isDataWeatherDeleted = true
        }
        weatherValue.formalName = cityName
        CoreDataHelper().storeData(weatherResponse: weatherValue)
        citiesWeathers.append(weatherValue)
        delegate?.receivedCitiesWeathers(citiesWeathers: citiesWeathers)
    }
    
    func requestCitiesWeathers() {
        for city in CityList.cityList {
            if city == StringConstant.CURRENT_LOCATION {
                requestLocationWeather(lat: locationManager.location?.coordinate.latitude.description, lon: locationManager.location?.coordinate.longitude.description, cityName: city)
            } else {
                requestCityWeather(cityName: city)
            }
        }
    }
    
    func requestWeathersIfLocationEnabled() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse && isLocationStatusEnabled == true {
            requestCitiesWeathers()
            isLocationStatusEnabled = false
        }
    }
}
