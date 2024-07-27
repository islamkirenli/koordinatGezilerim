import UIKit
import MapKit
import CoreLocation

class MapManager: NSObject, MKMapViewDelegate {
    
    let mapView: MKMapView
    let geocoder = CLGeocoder()
    
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
        let region = MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180))
        mapView.setRegion(region, animated: true)
        
        // Annotation ekle
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation
        mapView.addAnnotation(annotation)
        
        // Koordinatları şehir adına çevir
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
                annotation.title = "Unknown Location"
            } else if let placemark = placemarks?.first {
                annotation.title = placemark.locality ?? "Unknown Location"
            }
        }
    }
}

