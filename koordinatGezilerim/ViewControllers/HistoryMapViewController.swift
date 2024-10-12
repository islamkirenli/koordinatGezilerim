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
            // Kullanıcının konumu için varsayılan simgeyi kullanma
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Pin animasyonunu etkinleştir
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
