import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

class SignUpViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var spinWorldManager: SpinWorldManager!
    
    let togglePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal) // Kapalı göz ikonu
        button.tintColor = .gray
        return button
    }()
    
    let toggleConfirmPasswordButton: UIButton = {
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
        
        // Password TextField'ı kapsül şeklinde yap
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        passwordTextField.clipsToBounds = true
        
        confirmPasswordTextField.layer.cornerRadius = confirmPasswordTextField.frame.height / 2
        confirmPasswordTextField.clipsToBounds = true
        
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        let passwordRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)) // 40 genişliğinde bir alan
        togglePasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40) // İçeri doğru 5 birim padding
        passwordRightView.addSubview(togglePasswordButton)
        passwordTextField.rightView = passwordRightView
        passwordTextField.rightViewMode = .always
        
        toggleConfirmPasswordButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        let confirmPasswordRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        toggleConfirmPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        confirmPasswordRightView.addSubview(toggleConfirmPasswordButton)
        confirmPasswordTextField.rightView = confirmPasswordRightView
        confirmPasswordTextField.rightViewMode = .always

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

        
    }
    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle() // Şifre görünürlük durumu değiştirilir
        
        // İkona uygun güncelleme yapılır
        let iconName = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        togglePasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    @objc func toggleConfirmPasswordVisibility() {
        confirmPasswordTextField.isSecureTextEntry.toggle() // Şifre görünürlük durumu değiştirilir
        
        // İkona uygun güncelleme yapılır
        let iconName = confirmPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        toggleConfirmPasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }

    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text,
        let confirmPassword = confirmPasswordTextField.text else { return }

        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    // Hata durumunu ele alın
                    AlertManager.showAlert(title: "Error", message: "Kayıt hatası: \(error.localizedDescription)", viewController: self)
                } else {
                    // Başarılı kayıt, kullanıcıyı giriş yapmaya yönlendirin
                    print("Kayıt başarılı!")
                    self.handleSuccessfulSignUp()
                }
            }
        } else{
            AlertManager.showAlert(title: "Error", message: "şifre ve doğrulama şifresi aynı değil.", viewController: self)
        }
        
    }
    
    func handleSuccessfulSignUp() {
        // Dismiss the sign-up screen and navigate to the login screen
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: {
                // Trigger world growth animation after transitioning
                loginVC.startWorldGrowthAnimation()
            })
        }
    }
    
    @IBAction func signUpWithGoogleButton(_ sender: Any) {
        signInWithGoogle()
    }
    
    func signInWithGoogle(){
        Task { @MainActor in
            let success = await performSignInWithGoogle()
            if success {
                //başarılı kayıt.
                self.handleSuccessfulSignUp()
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
    
    @IBAction func signUpWithAppleButton(_ sender: Any) {
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
                    self.handleSuccessfulSignUp()
                } catch {
                    AlertManager.showAlert(title: "Error", message: "Apple sign up error: \(error.localizedDescription)", viewController: self)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        AlertManager.showAlert(title: "Error", message: "Sign up with Apple failed: \(error.localizedDescription)", viewController: self)
    }
}
