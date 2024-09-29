import UIKit
import MapKit
import FirebaseFirestore
import FirebaseAuth

class HistoryMapViewController: UIViewController, MKMapViewDelegate {

    var coordinates: [(city: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, isGone: Bool, uuid: String)] = []
    var mapView: MKMapView!
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Harita görünümü oluşturma
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        
        // Koordinatlara pin ekleyin
        addAnnotationsToMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Firestore'dan verileri yeniden çek
        fetchUpdatedCoordinatesFromFirestore()
    }

    
    func fetchUpdatedCoordinatesFromFirestore() {
        db.collection((currentUser?.email)!+"-CoordinateInformations").getDocuments { (snapshot, error) in
            if let error = error {
                AlertManager.showAlert(title: "Error", message: "Error getting documents: \(error)", viewController: self)
            } else {
                self.coordinates.removeAll() // Eski koordinatları temizle
                for document in snapshot!.documents {
                    let data = document.data()
                    let city = data["CityTitle"] as? String ?? "Unknown City"
                    let latitude = data["Latitude"] as? CLLocationDegrees ?? 0.0
                    let longitude = data["Longitude"] as? CLLocationDegrees ?? 0.0
                    let isGone = data["IsGone"] as? Bool ?? false
                    let uuid = data["UUID"] as? String ?? "Unknown UUID"
                    
                    if latitude != 0.0 && longitude != 0.0 && uuid != "Unknown UUID" {
                        self.coordinates.append((city: city, latitude: latitude, longitude: longitude, isGone: isGone, uuid: uuid))
                    }
                }
                
                // Haritayı yeniden yükleyin UI ana thread'de
                DispatchQueue.main.async {
                    self.reloadMapAnnotations()
                }
            }
        }
    }

    
    // Mevcut annotation'ları kaldırın ve yeniden ekleyin
    func reloadMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations) // Mevcut annotation'ları kaldır

        // Yeni verilerle annotation'ları yeniden ekleyin
        addAnnotationsToMap()
    }
    
    // Koordinatlara annotation ekleyin
    func addAnnotationsToMap() {
        for coordinate in coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            annotation.title = coordinate.city
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
            
            if let cityTitle = annotation.title as? String {
                if let coordinate = coordinates.first(where: { $0.city == cityTitle }) {
                    annotationView?.pinTintColor = coordinate.isGone ? .green : .red
                } else {
                    annotationView?.pinTintColor = .red
                }
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Annotation'a tıklama işlemini yakalama
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cityTitle = view.annotation?.title as? String {
            if let selectedCoordinate = coordinates.first(where: { $0.city == cityTitle }) {
                let selectedUUID = selectedCoordinate.uuid
                
                // Segue ile ShowVC'ye geçiş
                performSegue(withIdentifier: "toShowVC", sender: selectedUUID)
            }
        }
    }
    
    // Segue ile UUID'yi diğer VC'ye geçin
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowVC", let uuid = sender as? String {
            if let destinationVC = segue.destination as? ShowCoordinateViewController {
                destinationVC.uuid = uuid
            }
        }
    }
}
