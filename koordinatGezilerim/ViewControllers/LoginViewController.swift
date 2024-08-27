import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signinButtonOutlet: UIButton!
    
    var spinWorldManager: SpinWorldManager!
    
    var destinationVC = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "world_texture_cloud.jpg")!)
        
        // Email TextField'ı kapsül şeklinde yap
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.clipsToBounds = true
        
        // Password TextField'ı kapsül şeklinde yap
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        passwordTextField.clipsToBounds = true

        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds, radius: 0.1)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        
        // Kullanıcının küreye müdahale etmesini engelle
        spinWorldManager.sceneView.allowsCameraControl = false
        spinWorldManager.sphereNode.physicsBody = nil
        
        // SpinWorldManager'ın SceneView'ini ekleyin
        self.view.insertSubview(spinWorldManager.sceneView, at: 0)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        destinationVC = storyboard.instantiateViewController(withIdentifier: "NavController")
        
        destinationVC.view.alpha = 0.0  // Görünürlüğü sıfıra ayarlayın (görünmez)
        self.view.addSubview(destinationVC.view)
        self.addChild(destinationVC)
        
    }
    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Hata durumunu ele alın
                print("Giriş hatası: \(error.localizedDescription)")
            } else {
                // Başarılı giriş, kullanıcıyı başka bir ekrana yönlendirin
                print("Giriş başarılı!")
                
                // Giriş başarılı, küreyi büyüt ve butonları gizle
                UIView.animate(withDuration: 1.5, animations: {
                    self.emailTextField.alpha = 0
                    self.passwordTextField.alpha = 0
                    self.loginButtonOutlet.alpha = 0
                    self.signinButtonOutlet.alpha = 0
                })
                
                // Giriş başarılı, küreyi büyüt
                self.spinWorldManager.animateSphereGrowth(to: 2.0, duration: 3.0) {
                    // Küre büyüme işlemi tamamlandığında segue ile MainViewController'a geç
                    UIView.animate(withDuration: 2, animations: {
                        self.destinationVC.view.alpha = 1.0  // Görünürlüğü yavaş yavaş artır
                    }, completion: { _ in
                        self.destinationVC.didMove(toParent: self)
                    })
                }
            }
        }
    }
    
    @IBAction func signinButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Hata durumunu ele alın
                print("Kayıt hatası: \(error.localizedDescription)")
            } else {
                // Başarılı kayıt, kullanıcıyı giriş yapmaya yönlendirin
                print("Kayıt başarılı!")
                // Giriş ekranına yönlendirebilirsiniz
            }
        }
    }
}


