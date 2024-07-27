import Foundation

class RandomLandCoordinateGenerator {
    var latitude: Double
    var longitude: Double

    init() {
        self.latitude = 0.0
        self.longitude = 0.0
        generateNewCoordinates { (latitude, longitude) in
            self.latitude = latitude
            self.longitude = longitude
            print("İlk rastgele kara koordinatları: enlem = \(latitude), boylam = \(longitude)")
        }
    }

    static func randomLatitude() -> Double {
        return Double.random(in: -90.0...90.0)
        //return Double.random(in: 36.0...42.0)
    }

    static func randomLongitude() -> Double {
        return Double.random(in: -180.0...180.0)
        //return Double.random(in: 26.0...45.0)
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
                   let _ = address["country"] {
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

    func randomLandCoordinate(completion: @escaping (Double, Double) -> Void) {
        func checkCoordinates() {
            let latitude = RandomLandCoordinateGenerator.randomLatitude()
            let longitude = RandomLandCoordinateGenerator.randomLongitude()
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

    func generateNewCoordinates(completion: @escaping (Double, Double) -> Void) {
        randomLandCoordinate { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
            completion(latitude, longitude)
        }
    }
}
