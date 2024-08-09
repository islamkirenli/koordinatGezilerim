/*import UIKit
import FirebaseFirestore

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
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        self.view.addSubview(spinWorldManager.sceneView)
        
        // ButtonManager'ı oluştur ve butonları ayarla
        let startButtonFrame = CGRect(x: 85, y: 100, width: 250, height: 130)
        let settingsButtonFrame = CGRect(x: 15, y: 700, width: 130, height: 130)
        let historyButtonFrame = CGRect(x: 155, y: 700, width: 250, height: 130)
        buttonManager = ButtonManager(startButtonFrame: startButtonFrame, settingsButtonFrame: settingsButtonFrame, historyButtonFrame: historyButtonFrame)
        buttonManager.delegate = self
        
        // Butonları view'e ekle
        view.addSubview(buttonManager.startButton)
        view.addSubview(buttonManager.settingsButton)
        view.addSubview(buttonManager.historyButton)

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
        
        fetchSettingsDataFromFirebase()
    }
    
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinWorldManager.stopIncreasingRadius() // Geri dönüldüğünde küreyi sıfırla
        loadingLabel.isHidden = true // Geri dönüldüğünde loading etiketi gizle
        activityIndicator.stopAnimating() // Geri dönüldüğünde activity indicator'ı durdur
        fetchSettingsDataFromFirebase()
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
        
        // Koordinatları güncelle ve geçiş işlemini başlat
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
                self?.loadingLabel.isHidden = true
                self?.activityIndicator.stopAnimating() // Koordinatlar yüklendikten sonra activity indicator'ı durdur
                self?.latitude = latitude
                self?.longitude = longitude
                self?.spinWorldManager.startIncreasingRadius() // SpinWorldManager'ı başlat
            }
        }
    }
    
    func fetchSettingsDataFromFirebase() {
        let documentID = "settings" // Bu doküman ID'yi ihtiyacınıza göre belirleyin
        let docRef = db.collection("user").document(documentID)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self?.north = data?["north"] as? Double
                self?.south = data?["south"] as? Double
                self?.east = data?["east"] as? Double
                self?.west = data?["west"] as? Double
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                // Burada bir hata mesajı gösterebilir veya bir varsayılan işlem yapabilirsiniz
            }
        }
    }


}

// ButtonManagerDelegate protokolünü ekleyin
extension ViewController: ButtonManagerDelegate {
    func historyButtonTapped() {
        print("history tıklandı2.")
    }
    
    func startButtonTapped() {
        checkCoordinatesAndTransition()
    }
    
    func settingsButtonTapped(){
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
}
*/

import UIKit
import FirebaseFirestore

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
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        self.view.addSubview(spinWorldManager.sceneView)
        
        // ButtonManager'ı oluştur ve butonları ayarla
        let startButtonFrame = CGRect(x: 85, y: 100, width: 250, height: 130)
        let settingsButtonFrame = CGRect(x: 15, y: 700, width: 130, height: 130)
        let historyButtonFrame = CGRect(x: 155, y: 700, width: 250, height: 130)
        buttonManager = ButtonManager(startButtonFrame: startButtonFrame, settingsButtonFrame: settingsButtonFrame, historyButtonFrame: historyButtonFrame)
        buttonManager.delegate = self
        
        // Butonları view'e ekle
        view.addSubview(buttonManager.startButton)
        view.addSubview(buttonManager.settingsButton)
        view.addSubview(buttonManager.historyButton)
        
        // Ensure the buttons are visible initially
        self.view.bringSubviewToFront(buttonManager.startButton)
        self.view.bringSubviewToFront(buttonManager.settingsButton)
        self.view.bringSubviewToFront(buttonManager.historyButton)

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
        
        fetchSettingsDataFromFirebase()
    }
    
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinWorldManager.stopIncreasingRadius() // Geri dönüldüğünde küreyi sıfırla
        loadingLabel.isHidden = true // Geri dönüldüğünde loading etiketi gizle
        activityIndicator.stopAnimating() // Geri dönüldüğünde activity indicator'ı durdur
        fetchSettingsDataFromFirebase()
        self.view.bringSubviewToFront(buttonManager.startButton)
        self.view.bringSubviewToFront(buttonManager.settingsButton)
        self.view.bringSubviewToFront(buttonManager.historyButton)
        self.view.bringSubviewToFront(loadingLabel)
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
        
        // Koordinatları güncelle ve geçiş işlemini başlat
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
                self?.loadingLabel.isHidden = true
                self?.activityIndicator.stopAnimating() // Koordinatlar yüklendikten sonra activity indicator'ı durdur
                self?.latitude = latitude
                self?.longitude = longitude
                self?.startSphereExpansion()
            }
        }
    }

    private func startSphereExpansion() {
        // Bring the sphere to the front before starting the expansion
        UIView.animate(withDuration: 2.0, animations: {
            self.view.bringSubviewToFront(self.spinWorldManager.sceneView)
            self.spinWorldManager.startIncreasingRadius()
        })
    }
    
    func fetchSettingsDataFromFirebase() {
        let documentID = "settings" // Bu doküman ID'yi ihtiyacınıza göre belirleyin
        let docRef = db.collection("user").document(documentID)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self?.north = data?["north"] as? Double
                self?.south = data?["south"] as? Double
                self?.east = data?["east"] as? Double
                self?.west = data?["west"] as? Double
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                // Burada bir hata mesajı gösterebilir veya bir varsayılan işlem yapabilirsiniz
            }
        }
    }
}

// ButtonManagerDelegate protokolünü ekleyin
extension ViewController: ButtonManagerDelegate {
    func historyButtonTapped() {
        print("history tıklandı2.")
    }
    
    func startButtonTapped() {
        checkCoordinatesAndTransition()
    }
    
    func settingsButtonTapped(){
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
}
