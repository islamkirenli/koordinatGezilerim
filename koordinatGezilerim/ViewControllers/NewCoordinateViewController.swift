import UIKit
import MapKit
import Lottie

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
    
    var annotation = MKPointAnnotation()
    
    var animationView: LottieAnimationView!
    private var blurEffectView: UIVisualEffectView?
    
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
        
        animationView = LottieAnimationView(name: "search_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = self.view.center
        animationView.isHidden = true
        self.view.addSubview(animationView)
 
        let newCoordinateButton = UIButton(type: .custom)
        var config = UIButton.Configuration.filled()
        config.title = "New Coordinate" // Metin
        config.image = UIImage(systemName: "mappin.and.ellipse") // İkon
        config.baseForegroundColor = .black// Metin ve ikon rengi
        config.baseBackgroundColor = UIColor(hex: "#CACACA") // Butonun arka plan rengi
        config.imagePadding = 10 // İkon ile metin arasındaki boşluk
        config.imagePlacement = .leading // İkonu metnin soluna yerleştir
        newCoordinateButton.configuration = config
        
        newCoordinateButton.layer.cornerRadius = 10 // Yuvarlak köşeler
        newCoordinateButton.addTarget(self, action: #selector(newCoordinateButtonTapped), for: .touchUpInside)
        newCoordinateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newCoordinateButton)
        
        NSLayoutConstraint.activate([
            newCoordinateButton.widthAnchor.constraint(equalToConstant: 200),
            newCoordinateButton.heightAnchor.constraint(equalToConstant: 60),
            newCoordinateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCoordinateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.isHidden = true
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
            
            // Pin rengini ayarla (varsayılan: .red, .green, .purple)
            annotationView?.pinTintColor = .red
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    @objc func newCoordinateButtonTapped() {
        animationView.isHidden = false
        animationView.play()
        print("new coordinate tıklandı")
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime){
                    self?.animationView.stop()
                    self?.animationView.isHidden = true
                    self?.removeBlurEffect()

                    self?.latitude = latitude
                    self?.longitude = longitude
                    
                    // Mevcut annotation'ları kaldır
                    self?.mapManager.mapView.removeAnnotations(self?.mapManager.mapView.annotations ?? [])
                    
                    // Yeni annotation oluştur veya mevcut olanı güncelle
                    if self?.annotation == nil {
                        self?.annotation = MKPointAnnotation()
                    }
                    
                    // Yeni koordinatları mevcut annotation'a ata
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
                            
                            // Annotation'ı ekledikten sonra başlığı otomatik olarak göster
                            if let annotationView = self?.mapManager.mapView.view(for: self!.annotation) {
                                annotationView.canShowCallout = true
                                annotationView.isSelected = true  // Annotation'ı seçili hale getir
                            }
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


