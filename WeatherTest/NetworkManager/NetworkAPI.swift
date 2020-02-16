import Foundation
import Moya

enum WeatherAPI {
    case currentByCityName(String)
    case currentByLocation(String, String)
    case forecastByCityName(String, String)
}

import Foundation
import Moya

//Definition of network API methods
extension WeatherAPI: TargetType {
    var baseURL: URL { return URL(string: StringConstant.BASE_URL)! }
    var path: String {
        switch self {
        case .currentByCityName(_):
            return StringConstant.WEATHER
        case .currentByLocation(_, _):
            return StringConstant.WEATHER
        case .forecastByCityName(_, _):
            return StringConstant.FORECAST_DAILY
        }
    }

    var method: Moya.Method {
        switch self {
        case .currentByCityName(_), .currentByLocation(_, _), .forecastByCityName(_, _):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .currentByCityName(let cityName):
            return .requestParameters(
                parameters: ["q": cityName, "appid": StringConstant.API_KEY],
                encoding: URLEncoding.default)
        case .currentByLocation(let lat, let lon):
            return .requestParameters(
                parameters: ["lat": lat, "lon": lon, "appid": StringConstant.API_KEY],
                encoding: URLEncoding.default)
        case .forecastByCityName(let cityName, let days):
            return .requestParameters(
                parameters: ["q": cityName, "days": days, "appid": StringConstant.API_KEY],
                encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .currentByCityName, .currentByLocation(_, _), .forecastByCityName:
            return StringConstant.EMPTY_STRING.utf8Encoded
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
