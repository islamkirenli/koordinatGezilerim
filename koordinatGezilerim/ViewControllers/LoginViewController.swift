import UIKit
import FirebaseAuth
import FirebaseCore
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var appleSignInButtonOutlet: UIButton!
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!

    var spinWorldManager: SpinWorldManager!
    
    var destinationVC = UIViewController()
    
    let label = UILabel()
    let signUpButton = UIButton(type: .system)
    
    let togglePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal) // Kapalı göz ikonu
        button.tintColor = .gray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "world_texture_cloud.jpg")!)
        
        // Email TextField'ı kapsül şeklinde yap
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.clipsToBounds = true
        let emailPlaceholderText = "e-Mail"
        let emailPlaceholderColor = UIColor.lightGray
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: emailPlaceholderColor])

        
        // Password TextField'ı kapsül şeklinde yap
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        passwordTextField.clipsToBounds = true
        let passwordPlaceholderText = "Password"
        let passwordPlaceholderColor = UIColor.lightGray
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: passwordPlaceholderColor])
        
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        let passwordRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)) // 40 genişliğinde bir alan
        togglePasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40) // İçeri doğru 5 birim padding
        passwordRightView.addSubview(togglePasswordButton)
        passwordTextField.rightView = passwordRightView
        passwordTextField.rightViewMode = .always

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
        
        // UILabel yapılandır
        label.text = "Don't have an account?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        // UIButton yapılandır
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        // UIElement'leri view'e ekle
        view.addSubview(label)
        view.addSubview(signUpButton)
        
        // Auto Layout ayarla
        label.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        // UILabel ve UIButton'un yanyana hizalanmasını sağla
        NSLayoutConstraint.activate([
            // Label ortalamak
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Button ortalamak ve label'in sağında yerleştirmek
            signUpButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            signUpButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle() // Şifre görünürlük durumu değiştirilir
        
        // İkona uygun güncelleme yapılır
        let iconName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        togglePasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    // UIButton Action
    @objc func signUpTapped() {
        print("kaydol tıklandı.")
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    
    
    @IBAction func forgetPasswordButton(_ sender: Any) {
        performSegue(withIdentifier: "toForgetPasswordVC", sender: nil)
    }
    
    @IBAction func appleSignInButton(_ sender: Any) {
        print("apple butona basıldı.")
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    enum AuthenticationError: Error {
      case showAlert(message: String)
    }
    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Hata durumunu ele alın
                AlertManager.showAlert(title: "Error", message: "Giriş hatası: \(error.localizedDescription)", viewController: self)
            } else {
                // Başarılı giriş, kullanıcıyı başka bir ekrana yönlendirin
                print("Giriş başarılı!")
                
                // Giriş başarılı, küreyi büyüt ve butonları gizle
                UIView.animate(withDuration: 1.5, animations: {
                    self.emailTextField.alpha = 0
                    self.passwordTextField.alpha = 0
                    self.forgetPasswordButtonOutlet.alpha = 0
                    self.loginButtonOutlet.alpha = 0
                    self.appleSignInButtonOutlet.alpha = 0
                    self.label.alpha = 0
                    self.signUpButton.alpha = 0
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
    
    func startWorldGrowthAnimation() {
        // Giriş başarılı, küreyi büyüt ve butonları gizle
        UIView.animate(withDuration: 1.5, animations: {
            self.emailTextField.alpha = 0
            self.passwordTextField.alpha = 0
            self.forgetPasswordButtonOutlet.alpha = 0
            self.loginButtonOutlet.alpha = 0
            self.appleSignInButtonOutlet.alpha = 0
            self.label.alpha = 0
            self.signUpButton.alpha = 0
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

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let idTokenData = appleIDCredential.identityToken,
                  let idTokenString = String(data: idTokenData, encoding: .utf8) else {
                print("Apple ID token missing")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nil)
            
            Task { @MainActor in
                do {
                    let result = try await Auth.auth().signIn(with: credential)
                    let firebaseUser = result.user
                    print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
                    // Başarılı giriş işlemleri burada yapılabilir
                    // Giriş başarılı, küreyi büyüt ve butonları gizle
                    UIView.animate(withDuration: 1.5, animations: {
                        self.emailTextField.alpha = 0
                        self.passwordTextField.alpha = 0
                        self.forgetPasswordButtonOutlet.alpha = 0
                        self.loginButtonOutlet.alpha = 0
                        self.appleSignInButtonOutlet.alpha = 0
                        self.label.alpha = 0
                        self.signUpButton.alpha = 0
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
                } catch {
                    AlertManager.showAlert(title: "Error", message: "Apple sign in error: \(error.localizedDescription)", viewController: self)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        AlertManager.showAlert(title: "Error", message: "Sign in with Apple failed: \(error.localizedDescription)", viewController: self)
    }
}


