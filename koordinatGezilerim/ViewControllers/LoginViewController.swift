import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signinButtonOutlet: UIButton!
    @IBOutlet weak var googleSignInButtonOutlet: UIButton!
    @IBOutlet weak var appleSignInButtonOutlet: UIButton!
    
    var spinWorldManager: SpinWorldManager!
    
    var destinationVC = UIViewController()
    
    let label = UILabel()
    let signUpButton = UIButton(type: .system)

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
        
        // UILabel yapılandır
        label.text = "Don't have an account?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        
        // UIButton yapılandır
        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signUpButton.addTarget(self, action: #selector(kaydolTapped), for: .touchUpInside)
        
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
    
    // UIButton Action
    @objc func kaydolTapped() {
        print("kaydol tıklandı.")
    }
    
    @IBAction func googleSigninButton(_ sender: Any) {
        signInWithGoogle()
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
    
    func signInWithGoogle(){
        Task { @MainActor in
            let success = await performSignInWithGoogle()
            if success {
                // Giriş başarılı, küreyi büyüt ve butonları gizle
                UIView.animate(withDuration: 1.5, animations: {
                    self.emailTextField.alpha = 0
                    self.passwordTextField.alpha = 0
                    self.loginButtonOutlet.alpha = 0
                    self.signinButtonOutlet.alpha = 0
                    self.googleSignInButtonOutlet.alpha = 0
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
            } else {
                print("burda hata var.....")
            }
        }
    }
    
    func performSignInWithGoogle() async -> Bool {
      guard let clientID = FirebaseApp.app()?.options.clientID else {
        fatalError("No client ID found in Firebase configuration")
      }
      let config = GIDConfiguration(clientID: clientID)
      GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
        print("There is no root view controller!")
        return false
        }
        do {
          let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
          let user = userAuthentication.user
          guard let idToken = user.idToken else { throw AuthenticationError.showAlert(message: "ID token missing") }
          let accessToken = user.accessToken
          let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                         accessToken: accessToken.tokenString)
          let result = try await Auth.auth().signIn(with: credential)
          let firebaseUser = result.user
          print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
          return true
        }
        catch {
          print(error.localizedDescription)
          return false
        }
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
                    self.googleSignInButtonOutlet.alpha = 0
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
                        self.loginButtonOutlet.alpha = 0
                        self.signinButtonOutlet.alpha = 0
                        self.googleSignInButtonOutlet.alpha = 0
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
                    print("Apple sign in error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
    }
}


