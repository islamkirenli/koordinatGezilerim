import UIKit

class NewCoordinateViewController: UIViewController {
    
    var mapManager: MapManager!
    var latitude: Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let latitude = latitude, let longitude = longitude else { return }
        
        // MapManager oluştur ve haritayı ekle
        mapManager = MapManager(frame: self.view.bounds, latitude: latitude, longitude: longitude)
        self.view.addSubview(mapManager.mapView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Geri dönüldüğünde küreyi sıfırlamak için notification gönder
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetScene"), object: nil)
    }
}


