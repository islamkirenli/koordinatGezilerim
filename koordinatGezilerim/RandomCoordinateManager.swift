import Foundation

class RandomLandCoordinateGenerator {
    var latitude: Double
    var longitude: Double

    init() {
        self.latitude = 0.0
        self.longitude = 0.0
        generateNewCoordinates(latitudeRange: -90.0...90.0, longitudeRange: -180.0...180.0) { (latitude, longitude) in
            self.latitude = latitude
            self.longitude = longitude
            print("İlk rastgele kara koordinatları: enlem = \(latitude), boylam = \(longitude)")
        }
    }

    static func randomLatitude(in range: ClosedRange<Double>) -> Double {
        return Double.random(in: range)
    }

    static func randomLongitude(in range: ClosedRange<Double>) -> Double {
        return Double.random(in: range)
    }

    func isLand(latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        let urlString = "https://nominatim.openstreetmap.org/reverse?format=json&lat=\(latitude)&lon=\(longitude)&zoom=10&addressdetails=1"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let address = json["address"] as? [String: Any],
                   let country = address["country"] {
                    print(country)
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
        task.resume()
    }

    func randomLandCoordinate(latitudeRange: ClosedRange<Double>, longitudeRange: ClosedRange<Double>, completion: @escaping (Double, Double) -> Void) {
        func checkCoordinates() {
            let latitude = RandomLandCoordinateGenerator.randomLatitude(in: latitudeRange)
            let longitude = RandomLandCoordinateGenerator.randomLongitude(in: longitudeRange)
            isLand(latitude: latitude, longitude: longitude) { isLand in
                if isLand {
                    completion(latitude, longitude)
                } else {
                    checkCoordinates()
                }
            }
        }

        checkCoordinates()
    }

    func generateNewCoordinates(latitudeRange: ClosedRange<Double>, longitudeRange: ClosedRange<Double>, completion: @escaping (Double, Double) -> Void) {
        randomLandCoordinate(latitudeRange: latitudeRange, longitudeRange: longitudeRange) { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
            completion(latitude, longitude)
        }
    }
}


