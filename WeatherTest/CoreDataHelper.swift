import Foundation
import UIKit
import CoreData

class CoreDataHelper {
        
    func storeData(weatherResponse: WeatherResponse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let weatherEntity = NSEntityDescription.entity(forEntityName: "CityWeather", in: managedContext)
        
        let weatherManagedObj = NSManagedObject(entity: weatherEntity!, insertInto: managedContext)
        weatherManagedObj.setValue(weatherResponse.getName(), forKey: "name")
        weatherManagedObj.setValue(weatherResponse.getTemp(), forKey: "temperature")
        weatherManagedObj.setValue(weatherResponse.getFeelsLike(), forKey: "feelsLike")
        weatherManagedObj.setValue(weatherResponse.getWeatherDesc(), forKey: "weatherDesc")
        do {
            try managedContext.save()
        }
        catch {
            print("Coredata error")
        }
    }
    
    func storeData(forecast: ForecastResponse) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let forecastEntity = NSEntityDescription.entity(forEntityName: "Forecast", in: managedContext)
        
        let cityName = forecast.city?.name
        let forecastList = forecast.list!
        
        for forecastObject in forecastList {
            let forecastManagedObj = NSManagedObject(entity: forecastEntity!, insertInto: managedContext)
            forecastManagedObj.setValue(cityName, forKey: "name")
            forecastManagedObj.setValue(forecastObject.main?.temp, forKey: "temperature")
            forecastManagedObj.setValue(forecastObject.main?.feelsLike, forKey: "feelsLike")
            forecastManagedObj.setValue(forecastObject.weather?[0].weatherDescription, forKey: "weatherDesc")
            forecastManagedObj.setValue(forecastObject.dtTxt, forKey: "weatherTime")
        }
        do {
            try managedContext.save()
        }
        catch {
            print("Coredata error")
        }
    }
    
    func retrieveDataWeather() -> [WeatherResponse] {
        var cityWeathers = [WeatherResponse]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return cityWeathers}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityWeather")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                //cityWeathers.append(data as! WeatherResponse)
                cityWeathers.append(WeatherResponse(name: data.value(forKey: "name") as? String, temp: data.value(forKey: "temperature") as? Double, feelsLike: data.value(forKey: "feelsLike") as? Double, weatherDesc: data.value(forKey: "weatherDesc") as? String))
            }
        } catch {
            print("No data retrieved from CoreData")
        }
        return cityWeathers
    }
    
    func retrieveDataForecast(cityName: String) -> ForecastResponse? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        
        var forecastStoreArray = [ForecastStore]()
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", cityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                forecastStoreArray.append(ForecastStore(name: data.value(forKey: "name") as? String, temp: data.value(forKey: "temperature") as? Double, feelsLike: data.value(forKey: "feelsLike") as? Double, weatherDesc: data.value(forKey: "weatherDesc") as? String, time: data.value(forKey: "weatherTime") as? String))
            }
            return ForecastResponse(forecastStored: forecastStoreArray.sorted(by: { $0.time! < $1.time! }))
        } catch {
            print("No data retrieved from CoreData")
        }
        return nil
    }
    
    func deleteDataWeather() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CityWeather")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                managedContext.delete(data)
            }
        } catch {
            print("No data deleted from CoreData")
        }
        do {
            try managedContext.save()
        }
        catch {
            print("Coredata error")
        }
    }
    
    func deleteDataForecast(cityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        fetchRequest.predicate = NSPredicate(format: "name = %@", cityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                managedContext.delete(data)
            }
        } catch {
            print("No data deleted from CoreData")
        }
        do {
            try managedContext.save()
        }
        catch {
            print("Coredata error")
        }
    }
}
