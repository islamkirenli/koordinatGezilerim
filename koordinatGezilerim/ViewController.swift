import UIKit

class ViewController: UIViewController {
    
    var spinWorldManager: SpinWorldManager!
    var buttonManager: ButtonManager!
    var loadingLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    var coordinateGenerator: RandomLandCoordinateGenerator!
    var latitude: Double?
    var longitude: Double?
    var settingsData: [String: Any]?
    
    var north: Double?
    var south: Double?
    var east: Double?
    var west: Double?
    var selectedCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        self.view.addSubview(spinWorldManager.sceneView)
        
        // ButtonManager'ı oluştur ve butonları ayarla
        let startButtonFrame = CGRect(x: 80, y: 100, width: 250, height: 200)
        let settingsButtonFrame = CGRect(x: 40, y: 700, width: 100, height: 100)
        buttonManager = ButtonManager(startButtonFrame: startButtonFrame, settingsButtonFrame: settingsButtonFrame)
        buttonManager.delegate = self
        
        // Butonları view'e ekle
        view.addSubview(buttonManager.startButton)
        view.addSubview(buttonManager.settingsButton)
        
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
        } else if segue.identifier == "toSettingsVC", let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.delegate = self
        }
    }
    
    func checkCoordinatesAndTransition() {
        loadingLabel.isHidden = false
        activityIndicator.startAnimating() // Koordinatlar yüklenirken activity indicator'ı başlat
        coordinateGenerator = RandomLandCoordinateGenerator()
        
        coordinateGenerator.generateNewCoordinates(latitudeRange: south!...north!, longitudeRange: west!...east!) { [weak self] latitude, longitude in
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
    func startButtonTapped() {
        checkCoordinatesAndTransition()
    }
    
    func settingsButtonTapped(){
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
}

// SettingsViewControllerDelegate protokolünü ekleyin
extension ViewController: SettingsViewControllerDelegate {
    func didSaveSettings(data: [String: Any]) {
        if let north = data["north"] as? Double,
           let south = data["south"] as? Double,
           let east = data["east"] as? Double,
           let west = data["west"] as? Double,
           let country = data["country"] as? String {
            self.north = north
            self.south = south
            self.east = east
            self.west = west
            self.selectedCountry = country
        }
    }
}

