import UIKit
import MapKit

class NewCoordinateViewController: UIViewController, MKMapViewDelegate {
    
    var mapManager: MapManager!
    var latitude: Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let latitude = latitude, let longitude = longitude else { return }
        
        // MapManager oluştur ve haritayı ekle
        mapManager = MapManager(frame: self.view.bounds, latitude: latitude, longitude: longitude)
        mapManager.mapView.delegate = self
        self.view.addSubview(mapManager.mapView)
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
            destinationVC.annotationTitle = mapManager.annotationTitle
            destinationVC.annotationCountry = mapManager.annotationCountry
        }
    }
}
