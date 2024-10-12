import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    var spinWorldManager: SpinWorldManager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "world_texture_cloud.jpg")!)

        // SpinWorldManager oluştur ve SceneKit sahnesini ekle
        spinWorldManager = SpinWorldManager(frame: self.view.bounds, radius: 0.1)
        spinWorldManager.viewController = self // SpinWorldManager'a ViewController referansını ver
        
        // Kullanıcının küreye müdahale etmesini engelle
        spinWorldManager.sceneView.allowsCameraControl = false
        spinWorldManager.sphereNode.physicsBody = nil
        
        // SpinWorldManager'ın SceneView'ini ekleyin
        self.view.insertSubview(spinWorldManager.sceneView, at: 0)
        
        // Email TextField'ı kapsül şeklinde yap
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.clipsToBounds = true
        let emailPlaceholderText = "e-Mail"
        let emailPlaceholderColor = UIColor.lightGray
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: emailPlaceholderColor])
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }
    
    @IBAction func resetPasswordTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            AlertManager.showAlert(title: "Alert",message: "Lütfen geçerli bir e-posta adresi girin.", viewController: self)
            return
        }
        
        // Firebase method to send password reset email
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                AlertManager.showAlert(title: "Error",message: error.localizedDescription, viewController: self)
            } else {
                AlertManager.showAlert(title: "Success",message: "Şifre sıfırlama e-postası gönderildi. Lütfen e-postanızı kontrol edin.", viewController: self)
            }
        }
    }
}
