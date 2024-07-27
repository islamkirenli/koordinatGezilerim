import UIKit

class NewCoordinateViewController: UIViewController {

    var mapManager: MapManager!
    let randomCoordinateGenerator = RandomCoordinateGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // MapManager oluştur ve haritayı ekle
        mapManager = MapManager(frame: self.view.bounds, latitude: randomCoordinateGenerator.latitude, longitude: randomCoordinateGenerator.longitude)
        self.view.addSubview(mapManager.mapView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Geri dönüldüğünde küreyi sıfırlamak için notification gönder
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetScene"), object: nil)
    }

    
}
