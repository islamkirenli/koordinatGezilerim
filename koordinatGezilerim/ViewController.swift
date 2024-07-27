import UIKit

class ViewController: UIViewController {
    
    var spinWorldManager: SpinWorldManager!
    var buttonManager: ButtonManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SceneManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds)
        spinWorldManager.viewController = self // SceneManager'a ViewController referansını ver
        self.view.addSubview(spinWorldManager.sceneView)
        
        // ButtonManager oluştur ve butonu ekle
        let buttonFrame = CGRect(x: 80, y: 100, width: 250, height: 200) // Butonun çerçevesini ayarla
        buttonManager = ButtonManager(frame: buttonFrame)
        buttonManager.spinWorldManager = spinWorldManager
        self.view.addSubview(buttonManager.button)
        
        // Geri dönüldüğünde çağrılacak olan observer
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "resetScene"), object: nil)
    }
    
    @objc override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinWorldManager.stopIncreasingRadius() // Geri dönüldüğünde küreyi sıfırla
    }
}

