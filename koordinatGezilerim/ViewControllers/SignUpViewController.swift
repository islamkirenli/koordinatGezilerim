import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import AuthenticationServices

class SignUpViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var signUpWithAppleButtonOutlet: UIButton!
    
    var spinWorldManager: SpinWorldManager!
    
    let db = Firestore.firestore()
    
    var currentUser: User? = nil
    let coordinateDocumentID = "coordinateSettings"
    
    var coordinateSettings: [String: Any] = [:]
    
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
        let emailPlaceholderText = "e-Mail"
        let emailPlaceholderColor = UIColor.lightGray
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: emailPlaceholderColor])
        
        // Password TextField'ı kapsül şeklinde yap
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        passwordTextField.clipsToBounds = true
        let passwordPlaceholderText = "Password"
        let passwordPlaceholderColor = UIColor.lightGray
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: passwordPlaceholderColor])
        
        confirmPasswordTextField.layer.cornerRadius = confirmPasswordTextField.frame.height / 2
        confirmPasswordTextField.clipsToBounds = true
        let confirmPasswordPlaceholderText = "Confirm Password"
        let confirmPasswordPlaceholderColor = UIColor.lightGray
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: confirmPasswordPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor: confirmPasswordPlaceholderColor])
        
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

        // Auto Layout kısıtlamalarını manuel olarak uygulayacağız, bu yüzden translatesAutoresizingMaskIntoConstraints'i false yapıyoruz.
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        signUpWithAppleButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        
        // confirmPasswordTextField ekranın üst kısmında, ortalamak
        NSLayoutConstraint.activate([
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // Ekranın merkezinin üstüne, -60px
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 300),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // passwordTextField ekranın üst kısmında, ortalamak
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: confirmPasswordTextField.topAnchor, constant: -30),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // emailTextField ekranın üst kısmında, ortalamak
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -30),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        // signUpButtonOutlet ekranın üst kısmında, ortalamak
        NSLayoutConstraint.activate([
            signUpButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButtonOutlet.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100), // Ekranın merkezinin altına, 60px
            signUpButtonOutlet.widthAnchor.constraint(equalToConstant: 200),
            signUpButtonOutlet.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // signUpWithAppleButtonOutlet ekranın üst kısmında, ortalamak
        NSLayoutConstraint.activate([
            signUpWithAppleButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpWithAppleButtonOutlet.centerYAnchor.constraint(equalTo: signUpButtonOutlet.bottomAnchor, constant: 30),
            signUpWithAppleButtonOutlet.widthAnchor.constraint(equalToConstant: 200),
            signUpWithAppleButtonOutlet.heightAnchor.constraint(equalToConstant: 35)
        ])
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
                    AlertManager.showAlert(title: "Error", message: "Sign up error: \(error.localizedDescription)", viewController: self)
                } else {
                    // Başarılı kayıt, kullanıcıyı giriş yapmaya yönlendirin
                    print("Kayıt başarılı!")
                    self.currentUser = Auth.auth().currentUser
                    self.saveCoordinateSettings()
                    self.saveProfilSettings()
                    self.handleSuccessfulSignUp()
                }
            }
        } else{
            AlertManager.showAlert(title: "Error", message: "The password and confirm password do not match.", viewController: self)
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
                    self.currentUser = Auth.auth().currentUser
                    self.saveCoordinateSettings()
                    self.saveProfilSettings()
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
                //AlertManager.showAlert(title: "Saved", message: "Coordinate document successfully written!", viewController: self)
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
