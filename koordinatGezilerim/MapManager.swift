import UIKit
import MapKit
import CoreLocation

class MapManager: NSObject, MKMapViewDelegate {
    
    let mapView: MKMapView
    let geocoder = CLGeocoder()
    
    var annotationTitle: String!
    var annotationCountry: String!
    
    init(frame: CGRect, latitude: Double, longitude: Double) {
        // Harita görünümünü oluştur
        mapView = MKMapView(frame: frame)
        
        super.init()
        
        // Harita özelliklerini ayarla
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        
        // Başlangıç konumu
        let initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
        // Annotation ekle
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        mapView.addAnnotation(annotation)
        
        // Annotation ekledikten sonra haritayı ortala
        mapView.setRegion(regionThatFits(for: annotation.coordinate), animated: true)
        
        // Koordinatları şehir adına çevir
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
                annotation.title = "Unknown Location"
            } else if let placemark = placemarks?.first {
                annotation.title = placemark.locality ?? "Unknown Location"
                self.annotationTitle = placemark.locality ?? "Unknown Location"
                self.annotationCountry = placemark.country ?? "Unknown Country"
            }
        }
    }
    
    // Anotasyon koordinatına uygun bölge oluştur
    private func regionThatFits(for coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
}

