import UIKit
import SceneKit
import FirebaseFirestore

class SpinWorldManager {
    
    let sceneView: SCNView
    let scene: SCNScene
    let cameraNode: SCNNode
    let sphereNode: SCNNode
    var timer: Timer?
    var viewController: UIViewController?
    let db = Firestore.firestore()  // Firestore bağlantısı
    
    init(frame: CGRect) {
        // SceneKit Görüntüleyici
        sceneView = SCNView(frame: frame)
        
        // Sahne
        scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
        // Kamera
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        
        // Küre
        let sphere = SCNSphere(radius: 2)
        
        // Dünya Tekstürü
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "world_texture_cloud.jpg")
        sphere.materials = [material]
        
        // Dünya Node'u
        sphereNode = SCNNode(geometry: sphere)
        scene.rootNode.addChildNode(sphereNode)
        
        // Animasyon
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Double.pi * 2), z: 0, duration: 10)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        sphereNode.runAction(repeatAction)
        
        // Firestore'dan arka plan bilgisini çek
        fetchBackgroundFromFirestore()
    }
    
    func fetchBackgroundFromFirestore() {
        let documentID = "backgroundSettings"
        let docRef = db.collection("user").document(documentID)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let backgroundName = data["background"] as? String {
                    self?.updateBackground(with: backgroundName)
                }
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func updateBackground(with backgroundName: String) {
        if let spaceBackground = UIImage(named: backgroundName) {
            scene.background.contents = spaceBackground
        } else {
            print("Background image not found: \(backgroundName)")
        }
    }
    
    func startIncreasingRadius() {
        stopIncreasingRadius() // Önceki timer'ı durdur
        timer = Timer.scheduledTimer(timeInterval: 0.0004, target: self, selector: #selector(increaseRadius), userInfo: nil, repeats: true)
    }
    
    @objc func increaseRadius() {
        let currentRadius = (sphereNode.geometry as? SCNSphere)?.radius ?? 1.0
        let newRadius = currentRadius + 0.001
        
        // Ekranı kapladığında durması ve yeni ViewController'a geçiş yapması için kontrol
        if newRadius >= 6 { // Bu değeri ekran boyutlarına göre ayarlayabilirsiniz
            timer?.invalidate()
            timer = nil
            transitionToNewViewController()
        } else {
            (sphereNode.geometry as? SCNSphere)?.radius = newRadius
        }
    }
    
    func transitionToNewViewController() {
        guard let viewController = viewController else { return }
        
        viewController.performSegue(withIdentifier: "toNewCoordinateVC", sender: nil)
    }
    
    func stopIncreasingRadius() {
        timer?.invalidate()
        timer = nil
        (sphereNode.geometry as? SCNSphere)?.radius = 2.0
    }
}
