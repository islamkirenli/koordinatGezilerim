import Foundation

class RandomCoordinateGenerator {
    var latitude: Double
    var longitude: Double

    init() {
        self.latitude = RandomCoordinateGenerator.randomLatitude()
        self.longitude = RandomCoordinateGenerator.randomLongitude()
    }

    static func randomLatitude() -> Double {
        return Double.random(in: -90.0...90.0)
    }

    static func randomLongitude() -> Double {
        return Double.random(in: -180.0...180.0)
    }

    func generateNewCoordinates() {
        self.latitude = RandomCoordinateGenerator.randomLatitude()
        self.longitude = RandomCoordinateGenerator.randomLongitude()
    }
}

/*
// Kullanım örneği
let randomCoordinateGenerator = RandomCoordinateGenerator()
print("İlk rastgele koordinatlar: enlem = \(randomCoordinateGenerator.latitude), boylam = \(randomCoordinateGenerator.longitude)")

// Yeni rastgele koordinatlar oluşturma
randomCoordinateGenerator.generateNewCoordinates()
print("Yeni rastgele koordinatlar: enlem = \(randomCoordinateGenerator.latitude), boylam = \(randomCoordinateGenerator.longitude)")
*/
