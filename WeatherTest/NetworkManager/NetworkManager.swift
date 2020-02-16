import Foundation
import Moya

class NetworkManager {
    var provider = MoyaProvider<WeatherAPI>()
    
    func weatherByCity(cityName: String, completion: @escaping (WeatherResponse?, Error?) -> ()) {
        provider.request(.currentByCityName(cityName)) { result in
            switch result {
            case let .success(moyaResponse):
                let decoder = JSONDecoder()
                do {
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: moyaResponse.data)
                    completion(weatherResponse, nil)
                }
                catch {
                    print("Error: did not receive any weather")
                }
            case .failure(_): break
            }
        }
    }
    
    func forecastByCity(cityName: String, days: String, completion: @escaping (ForecastResponse?, Error?) -> ()) {
        provider.request(.forecastByCityName(cityName, days)) { result in
            switch result {
            case let .success(moyaResponse):
                let decoder = JSONDecoder()
                do {
                    let forecastResponse = try decoder.decode(ForecastResponse.self, from: moyaResponse.data)
                    completion(forecastResponse, nil)
                }
                catch {
                    print("Error: did not receive any forecast")
                }
            case .failure(_): break
            }
        }
    }
    
    func weatherByLocation(lat: String, lon: String, completion: @escaping (WeatherResponse?, Error?) -> ()) {
        provider.request(.currentByLocation(lat, lon)) { result in
            switch result {
            case let .success(moyaResponse):
                let decoder = JSONDecoder()
                do {
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: moyaResponse.data)
                    completion(weatherResponse, nil)
                }
                catch {
                    print("Error: did not receive any weather")
                }
            case .failure(_): break
            }
        }
    }
}
