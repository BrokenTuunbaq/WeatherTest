import Foundation

struct ForecastResponse: Codable {
    var cod: String?
    var message, cnt: Int?
    var list: [List]?
    var city: City?
    
    init(forecastStored: [ForecastStore]) {
        city?.name = forecastStored[0].name
        city?.formalName = forecastStored[0].formalName
        list = [List]()
        for stored in forecastStored {
            list?.append(List(temp: stored.temp, feels: stored.feelsLike, weatherDesc: stored.weatherDesc, weatherTime: stored.time))
        }
    }
}

struct City: Codable {
    var id: Int?
    var name: String?
    var formalName: String?
    var coord: Coord?
    var country: String?
    var population, timezone, sunrise, sunset: Int?
}

struct List: Codable {
    var dt: Int?
    var main: MainForecast?
    var weather: [Weather]?
    var clouds: Clouds?
    var wind: Wind?
    var sys: SysForecast?
    var dtTxt: String?

    init(temp: Double?, feels: Double?, weatherDesc: String?, weatherTime: String?) {
        dtTxt = weatherTime
        main = MainForecast(temp: temp, feelsLike: feels)
        weather = [Weather]()
        weather?.append(Weather(weatherDesc: weatherDesc))
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
}

struct MainForecast: Codable {
    var temp, feelsLike, tempMin, tempMax: Double?
    var pressure, seaLevel, grndLevel, humidity: Int?
    var tempKf: Double?
    
    init(temp: Double?, feelsLike: Double?) {
        self.temp = temp
        self.feelsLike = feelsLike
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct SysForecast: Codable {
    var pod: String?
}
