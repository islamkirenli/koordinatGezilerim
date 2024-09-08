import UIKit
import MapKit

class NewCoordinateViewController: UIViewController, MKMapViewDelegate {
    
    var mapManager: MapManager!
    var latitude: Double!
    var longitude: Double!
    let geocoder = CLGeocoder()
    var annotationTitle: String!
    var annotationCountry: String!
    
    var coordinateGenerator: RandomLandCoordinateGenerator!
    var north: Double?
    var south: Double?
    var east: Double?
    var west: Double?
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let latitude = latitude, let longitude = longitude else { return }
        
        // MapManager oluştur ve haritayı ekle
        mapManager = MapManager(frame: self.view.bounds, latitude: latitude, longitude: longitude)
        mapManager.mapView.delegate = self
        self.view.addSubview(mapManager.mapView)
        
        // Koordinatları şehir adına çevir
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                self.annotationTitle = placemark.locality ?? "Unknown Location"
                self.annotationCountry = placemark.country ?? "Unknown Country"
            }
        }
 
        let newCoordinateButton = UIButton(type: .custom)
        newCoordinateButton.setImage(UIImage(named: "startButton"), for: .normal)
        newCoordinateButton.addTarget(self, action: #selector(newCoordinateButtonTapped), for: .touchUpInside)
        newCoordinateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newCoordinateButton)
        
        NSLayoutConstraint.activate([
            newCoordinateButton.widthAnchor.constraint(equalToConstant: 220),
            newCoordinateButton.heightAnchor.constraint(equalToConstant: 100),
            newCoordinateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCoordinateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    
    @objc func newCoordinateButtonTapped() {
        print("new coordinate tıklandı")
        generateCoordinatesAndTransition()
    }
    
    
    private func generateCoordinatesAndTransition() {
        guard let north = north, let south = south, let east = east, let west = west else {
            print("Koordinatlar eksik")
            return
        }
        
        coordinateGenerator = RandomLandCoordinateGenerator()
        
        coordinateGenerator.generateNewCoordinates(latitudeRange: south...north, longitudeRange: west...east) { [weak self] latitude, longitude in
            DispatchQueue.main.async {
                // self?.activityIndicator.stopAnimating() // Koordinatlar yüklendikten sonra activity indicator'ı durdur
                self?.latitude = latitude
                self?.longitude = longitude
                
                // Mevcut annotation'ları kaldır
                self?.mapManager.mapView.removeAnnotations(self?.mapManager.mapView.annotations ?? [])
                
                // Yeni bir MapManager oluşturmanıza gerek yok, sadece yeni annotation ekleyebilirsiniz
                self?.annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                // Koordinatları şehir adına çevir
                let location = CLLocation(latitude: latitude, longitude: longitude)
                self?.geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let error = error {
                        print("Reverse geocode failed: \(error.localizedDescription)")
                        self?.annotation.title = "Unknown Location"
                    } else if let placemark = placemarks?.first {
                        self?.annotation.title = placemark.locality ?? "Unknown Location"
                        self?.annotationTitle = placemark.locality ?? "Unknown Location"
                        self?.annotationCountry = placemark.country ?? "Unknown Country"
                    }
                }
                
                // Yeni annotation'ı MapView'a ekle
                self?.mapManager.mapView.addAnnotation(self!.annotation)
                
                // Haritayı annotation'ın merkezine getir
                let coordinateRegion = MKCoordinateRegion(center: (self?.annotation.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                self?.mapManager.mapView.setRegion(coordinateRegion, animated: true)
            }
        }


    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Geri dönüldüğünde küreyi sıfırlamak için notification gönder
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetScene"), object: nil)
    }
    
    // MKMapViewDelegate method for selecting an annotation view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Perform segue to toSaveCoordinateVC
        performSegue(withIdentifier: "toSaveCoordinateVC", sender: view.annotation?.coordinate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSaveCoordinateVC",
           let destinationVC = segue.destination as? SaveCoordinateViewController,
           let coordinate = sender as? CLLocationCoordinate2D {
            destinationVC.latitude = coordinate.latitude
            destinationVC.longitude = coordinate.longitude
            destinationVC.annotationTitle = self.annotationTitle
            destinationVC.annotationCountry = self.annotationCountry
        }
    }
}
