import UIKit

class ViewController: UIViewController {
    
    var spinWorldManager: SpinWorldManager!
    var buttonManager: ButtonManager!
    var loadingLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    var coordinateGenerator: RandomLandCoordinateGenerator!
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        self.view.addSubview(spinWorldManager.sceneView)
        
        // ButtonManager oluştur ve butonu ekle
        let buttonFrame = CGRect(x: 80, y: 100, width: 250, height: 200) // Butonun çerçevesini ayarla
        buttonManager = ButtonManager(frame: buttonFrame)
        buttonManager.delegate = self
        self.view.addSubview(buttonManager.button)
        
        // Loading etiketi ekle
        loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        loadingLabel.center = self.view.center
        loadingLabel.textAlignment = .center
        loadingLabel.text = "New Coordinate Loading..."
        loadingLabel.isHidden = true
        loadingLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5) // Arka planı açık gri ve yarı saydam yap
        loadingLabel.numberOfLines = 0
        self.view.addSubview(loadingLabel)
        
        // Activity Indicator ekle
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = CGPoint(x: loadingLabel.frame.width / 2, y: loadingLabel.frame.height / 2 - 30)
        activityIndicator.hidesWhenStopped = true
        loadingLabel.addSubview(activityIndicator)
        
        // Geri dönüldüğünde çağrılacak olan observer
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "resetScene"), object: nil)
    }
    
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinWorldManager.stopIncreasingRadius() // Geri dönüldüğünde küreyi sıfırla
        loadingLabel.isHidden = true // Geri dönüldüğünde loading etiketi gizle
        activityIndicator.stopAnimating() // Geri dönüldüğünde activity indicator'ı durdur
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewCoordinateVC", let destinationVC = segue.destination as? NewCoordinateViewController {
            if let latitude = latitude, let longitude = longitude {
                destinationVC.latitude = latitude
                destinationVC.longitude = longitude
            }
        }
    }
    
    func checkCoordinatesAndTransition() {
        loadingLabel.isHidden = false
        activityIndicator.startAnimating() // Koordinatlar yüklenirken activity indicator'ı başlat
        coordinateGenerator = RandomLandCoordinateGenerator()
        
        coordinateGenerator.generateNewCoordinates { [weak self] latitude, longitude in
            DispatchQueue.main.async {
                self?.loadingLabel.isHidden = true
                self?.activityIndicator.stopAnimating() // Koordinatlar yüklendikten sonra activity indicator'ı durdur
                self?.latitude = latitude
                self?.longitude = longitude
                self?.spinWorldManager.startIncreasingRadius() // SpinWorldManager'ı başlat
            }
        }
    }
}

// ButtonManagerDelegate protokolünü ekleyin
extension ViewController: ButtonManagerDelegate {
    func buttonTapped() {
        checkCoordinatesAndTransition()
    }
}

