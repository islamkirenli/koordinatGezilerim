import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var appleSignInButtonOutlet: UIButton!
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!

    var spinWorldManager: SpinWorldManager!
    
    var destinationVC = UIViewController()
    
    let db = Firestore.firestore()
    var currentUser: User? = nil
    
    var coordinateSettings: [String: Any] = [:]
    let coordinateDocumentID = "coordinateSettings"
    
    var north: Double? //= 90.0
    var south: Double? //= -90.0
    var east: Double? //= 180.0
    var west: Double? //= -180.0
    
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
        
        // Auto Layout kısıtlamalarını manuel olarak uygulayacağız, bu yüzden translatesAutoresizingMaskIntoConstraints'i false yapıyoruz.
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        appleSignInButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        
        // Email TextField'ı ekranın üst kısmında, ortalamak
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150), // Ekranın merkezinin üstüne, -150px
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // Password TextField'ı, emailTextField'ın altına yerleştirmek
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20), // emailTextField'ın 20px altında
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // Forget Password Button'ı, passwordTextField'ın sağ alt köşesine yerleştirmek
        NSLayoutConstraint.activate([
            forgetPasswordButtonOutlet.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10), // Sağda 10px boşluk
            forgetPasswordButtonOutlet.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5), // Password TextField'ın 5px altında
            forgetPasswordButtonOutlet.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Login Button'ı, ekranın alt yarısına yerleştirmek (email ve password textField'larından biraz boşluk bırakıyoruz)
        NSLayoutConstraint.activate([
            loginButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButtonOutlet.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 60), // Password TextField'dan 100px aşağıda
            loginButtonOutlet.widthAnchor.constraint(equalToConstant: 200),
            loginButtonOutlet.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Apple SignIn Button'ı, Login Button'ın altına yerleştirmek
        NSLayoutConstraint.activate([
            appleSignInButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleSignInButtonOutlet.topAnchor.constraint(equalTo: loginButtonOutlet.bottomAnchor, constant: 20), // Login Button'ın 20px altında
            appleSignInButtonOutlet.widthAnchor.constraint(equalToConstant: 200),
            appleSignInButtonOutlet.heightAnchor.constraint(equalToConstant: 35)
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
                AlertManager.showAlert(title: "Error", message: "Login error: \(error.localizedDescription)", viewController: self)
            } else {
                // Başarılı giriş, kullanıcıyı başka bir ekrana yönlendirin
                print("Giriş başarılı!")
                
                self.currentUser = Auth.auth().currentUser
                self.fetchSettingsDataFromFirebase()
                
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
    
    func fetchSettingsDataFromFirebase() {
        let documentID = "coordinateSettings" // Bu doküman ID'yi ihtiyacınıza göre belirleyin
        if let currentUserEmail = currentUser?.email {
            let docRef = db.collection(currentUserEmail).document(documentID)
            
            docRef.getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self?.north = data?["north"] as? Double
                    self?.south = data?["south"] as? Double
                    self?.east = data?["east"] as? Double
                    self?.west = data?["west"] as? Double
                    
                    // Verileri NavigationController içindeki MainViewController'a aktar
                    if let navController = self?.destinationVC as? UINavigationController,
                       let mainVC = navController.viewControllers.first as? MainViewController {
                        mainVC.north = self?.north
                        mainVC.south = self?.south
                        mainVC.east = self?.east
                        mainVC.west = self?.west
                        mainVC.currentUser = self?.currentUser
                    }
                } else {
                    AlertManager.showAlert(title: "Error", message: "Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")", viewController: self!)
                }
            }
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
                    self.currentUser = Auth.auth().currentUser
                    
                    // Kullanıcının verileri var mı kontrol et
                    let userDocumentRef = db.collection(firebaseUser.email!).document("profilSettings")
                    userDocumentRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            // Kullanıcı daha önce giriş yapmış, veriler var
                            self.fetchSettingsDataFromFirebase()
                        } else {
                            // Kullanıcı daha önce giriş yapmamış, yeni veriler kaydedilmeli
                            self.saveProfilSettings()
                            self.saveCoordinateSettings()
                        }
                    }
                    
                    
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
    
    func saveCoordinateSettings(){
        coordinateSettings["north"] = 90.0
        coordinateSettings["south"] = -90.0
        coordinateSettings["east"] = 180.0
        coordinateSettings["west"] = -180.0
        coordinateSettings["country"] = "Global"
        
        // Koordinat verilerini Firebase'e kaydet
        db.collection((currentUser?.email)!).document(coordinateDocumentID).setData(coordinateSettings) { error in
            if let error = error {
                AlertManager.showAlert(title: "Error", message: "Error writing coordinate document: \(error)", viewController: self)
            } else {
                self.north = self.coordinateSettings["north"] as? Double
                self.south = self.coordinateSettings["south"] as? Double
                self.east = self.coordinateSettings["east"] as? Double
                self.west = self.coordinateSettings["west"] as? Double
                
                // Verileri NavigationController içindeki MainViewController'a aktar
                if let navController = self.destinationVC as? UINavigationController,
                   let mainVC = navController.viewControllers.first as? MainViewController {
                    mainVC.north = self.north
                    mainVC.south = self.south
                    mainVC.east = self.east
                    mainVC.west = self.west
                    mainVC.currentUser = self.currentUser
                }
                
                print("Coordinate document successfully written!")
            }
        }
    }
    
    func saveProfilSettings(){
        db.collection((currentUser?.email)!).document("profilSettings").setData([
            "name": "",
            "surname": "",
            "email": currentUser?.email,
            "avatar": "avatar-1",
        ]) { error in
            if let error = error {
                // Hata durumunu işle
                AlertManager.showAlert(title: "Error", message: "Error writing document: \(error)", viewController: self)
            } else {
                // Başarılı yazma
                //AlertManager.showAlert(title: "Saved", message: "Your information has been successfully saved.", viewController: self)
                print("profil ayarları kaydedildi.")
            }
        }
    }
}


