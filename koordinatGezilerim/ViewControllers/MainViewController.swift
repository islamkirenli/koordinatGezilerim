import UIKit
import FirebaseFirestore
import Lottie

class MainViewController: UIViewController {
    
    var spinWorldManager: SpinWorldManager!
    var buttonManager: ButtonManager!
    var coordinateGenerator: RandomLandCoordinateGenerator!
    var latitude: Double?
    var longitude: Double?
    
    var north: Double?
    var south: Double?
    var east: Double?
    var west: Double?
    var selectedCountry: String?
    var backgroundImage: String?
    
    var sloganLabel: UILabel!
    
    var animationView: LottieAnimationView!
    private var blurEffectView: UIVisualEffectView?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "world_texture_cloud.jpg")!)
        
        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds, radius: 2)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        self.view.addSubview(spinWorldManager.sceneView)
        
        // ButtonManager'ı oluştur ve butonları ayarla
        let startButtonFrame = CGRect(x: 105, y: 670, width: 200, height: 60)
        let settingsButtonFrame = CGRect(x: 330, y: 80, width: 70, height: 70)
        let historyButtonFrame = CGRect(x: 15, y: 80, width: 70, height: 70)
        buttonManager = ButtonManager(startButtonFrame: startButtonFrame, settingsButtonFrame: settingsButtonFrame, historyButtonFrame: historyButtonFrame)
        buttonManager.delegate = self
        
        // Slogan Label'ı oluştur ve startButton'un altında konumlandır
        sloganLabel = UILabel(frame: CGRect(x: 0, y: buttonManager.historyButton.frame.maxY + 35, width: self.view.bounds.width, height: 50))
        sloganLabel.textAlignment = .center
        //sloganLabel.font = UIFont.systemFont(ofSize: 18)
        sloganLabel.font = UIFont.italicSystemFont(ofSize: 18)
        sloganLabel.textColor = .white
        sloganLabel.numberOfLines = 2 // Sınırsız satır sayısı, yazı satırlara bölünebilir
        sloganLabel.lineBreakMode = .byWordWrapping // Kelimelere göre satır kırma
        
        // Butonları view'e ekle
        view.addSubview(buttonManager.startButton)
        view.addSubview(buttonManager.settingsButton)
        view.addSubview(buttonManager.historyButton)
        view.addSubview(sloganLabel)
        
        // Ensure the buttons are visible initially
        self.view.bringSubviewToFront(buttonManager.startButton)
        self.view.bringSubviewToFront(buttonManager.settingsButton)
        self.view.bringSubviewToFront(buttonManager.historyButton)
        self.view.bringSubviewToFront(sloganLabel)
        
        // Butonları başlangıçta görünmez yap
        buttonManager.startButton.alpha = 0
        buttonManager.settingsButton.alpha = 0
        buttonManager.historyButton.alpha = 0
        sloganLabel.alpha = 0
        
        // Görünürlük animasyonu
        UIView.animate(withDuration: 2) {
            self.buttonManager.startButton.alpha = 1
            self.buttonManager.settingsButton.alpha = 1
            self.buttonManager.historyButton.alpha = 1
            self.sloganLabel.alpha = 1
        }
        
        animationView = LottieAnimationView(name: "search_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = self.view.center
        animationView.isHidden = true
        self.view.addSubview(animationView)

        
        // Geri dönüldüğünde çağrılacak olan observer
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "resetScene"), object: nil)
        
        // NotificationCenter dinleyicisi ekle
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackgroundChange), name: NSNotification.Name("BackgroundDidChange"), object: nil)
        
        fetchSettingsDataFromFirebase()
        
        // Rastgele bir slogan seç ve göster
        displayRandomSlogan()

    }
    
    func displayRandomSlogan() {
        // Rastgele bir indeks seç
        let randomIndex = Int.random(in: 0..<SloganManager.sloganArray.count)
        // Seçilen sloganı göster
        sloganLabel.text = SloganManager.sloganArray[randomIndex]
    }
    
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayRandomSlogan()
        UIView.animate(withDuration: 2) {
            self.buttonManager.startButton.alpha = 1
            self.buttonManager.settingsButton.alpha = 1
            self.buttonManager.historyButton.alpha = 1
            self.sloganLabel.alpha = 1
        }
        spinWorldManager.stopIncreasingRadius() // Geri dönüldüğünde küreyi sıfırla
        animationView.isHidden = true
        fetchSettingsDataFromFirebase()
        self.view.bringSubviewToFront(buttonManager.startButton)
        self.view.bringSubviewToFront(buttonManager.settingsButton)
        self.view.bringSubviewToFront(buttonManager.historyButton)
        self.view.bringSubviewToFront(sloganLabel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewCoordinateVC", let destinationVC = segue.destination as? NewCoordinateViewController {
            if let latitude = latitude,
               let longitude = longitude,
               let east = east,
               let west = west,
               let north = north,
               let south = south{
                destinationVC.latitude = latitude
                destinationVC.longitude = longitude
                destinationVC.east = east
                destinationVC.west = west
                destinationVC.north = north
                destinationVC.south = south
            }
        }
    }
    
    func checkCoordinatesAndTransition() {
        animationView.isHidden = false
        animationView.play()
        
        // Koordinatları güncelle ve geçiş işlemini başlat
        generateCoordinatesAndTransition()
    }

    private func generateCoordinatesAndTransition() {
        guard let north = north, let south = south, let east = east, let west = west else {
            print("Koordinatlar eksik")
            return
        }
        
        coordinateGenerator = RandomLandCoordinateGenerator()
        
        let minimumAnimationDuration: TimeInterval = 3.0 // En az 3 saniye animasyon gösterimi
        let animationStartTime = Date() // Animasyonun başladığı zamanı kaydediyoruz

        // Arka plana bulanıklık efekti ekle
        addBlurEffect()

        coordinateGenerator.generateNewCoordinates(latitudeRange: south...north, longitudeRange: west...east) { [weak self] latitude, longitude in
            DispatchQueue.main.async {
                let timeElapsed = Date().timeIntervalSince(animationStartTime)
                let remainingTime = max(0, minimumAnimationDuration - timeElapsed) // 3 saniye dolmadıysa kalan süre
                
                // Geri kalan süreyi bekle ve ardından animasyonu durdur
                DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime) {
                    self?.animationView.stop()
                    self?.animationView.isHidden = true
                    self?.latitude = latitude
                    self?.longitude = longitude
                    self?.startSphereExpansion()

                    // Bulanıklık efektini kaldır
                    self?.removeBlurEffect()
                }
            }
        }
    }
    
    private func addBlurEffect() {
        // Bulanıklık efekti oluştur
        let blurEffect = UIBlurEffect(style: .regular) // İsteğe göre `.light` veya `.extraLight` seçilebilir
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
        if let blurView = blurEffectView {
            // Blur view'ı en alta ekle
            blurView.alpha = 0
            self.view.insertSubview(blurView, belowSubview: animationView)

            // Butonları blur effect'in arkasına yerleştir
            self.view.bringSubviewToFront(animationView)  // Animasyon net gözükmeli
            self.view.sendSubviewToBack(buttonManager.startButton)
            self.view.sendSubviewToBack(buttonManager.settingsButton)
            self.view.sendSubviewToBack(buttonManager.historyButton)
            self.view.sendSubviewToBack(sloganLabel)
            
            UIView.animate(withDuration: 0.5) {
                blurView.alpha = 1.0
            }
        }
    }

    private func removeBlurEffect() {
        // Bulanıklık efektini animasyonla kaldır
        if let blurView = blurEffectView {
            UIView.animate(withDuration: 0.5, animations: {
                blurView.alpha = 0.0
            }) { _ in
                blurView.removeFromSuperview()
            }
        }
    }


    private func startSphereExpansion() {
        // Bring the sphere to the front before starting the expansion
        UIView.animate(withDuration: 2.0, animations: {
            UIView.animate(withDuration: 2) {
                self.buttonManager.startButton.alpha = 0
                self.buttonManager.settingsButton.alpha = 0
                self.buttonManager.historyButton.alpha = 0
                self.sloganLabel.alpha = 0
            }
            self.spinWorldManager.startIncreasingRadius()
        })
    }
    
    func fetchSettingsDataFromFirebase() {
        let documentID = "coordinateSettings" // Bu doküman ID'yi ihtiyacınıza göre belirleyin
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("BackgroundDidChange"), object: nil)
    }

    @objc func handleBackgroundChange() {
        print("Background has changed, updating scene.")
        spinWorldManager.fetchBackgroundFromFirestore()
    }
}

// ButtonManagerDelegate protokolünü ekleyin
extension MainViewController: ButtonManagerDelegate {
    func historyButtonTapped() {
        print("history tıklandı2.")
        performSegue(withIdentifier: "toHistoryVC", sender: nil)
    }
    
    func startButtonTapped() {
        checkCoordinatesAndTransition()
    }
    
    func settingsButtonTapped(){
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
}
