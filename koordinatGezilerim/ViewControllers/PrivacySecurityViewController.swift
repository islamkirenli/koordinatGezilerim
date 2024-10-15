import UIKit
import FirebaseAuth
import FirebaseFirestore

class PrivacySecurityViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var deleteAccountSwitch: UISwitch!
    @IBOutlet weak var deleteAccountTextView: UITextView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    let placeholderLabel = UILabel()
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    var originalYPosition: CGFloat = 0 // Orijinal view pozisyonunu saklamak için
    
    let toggleCurrentPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    let toggleNewPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    let toggleConfirmNewPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding the "Read" button to the navigation bar
        let readButton = UIBarButtonItem(title: "Read", style: .plain, target: self, action: #selector(readButtonTapped))
        self.navigationItem.rightBarButtonItem = readButton
        
        // Şifre gösterme/gizleme butonları ekleniyor
        setupPasswordToggleButtons()
        
        // deleteAccountTextView için delegasyon atanıyor
        deleteAccountTextView.delegate = self
        
        // Klavye olaylarını dinlemek için Notification ekliyoruz
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Klavyeyi kapatmak için tap gesture ekleniyor
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        // İlk başta deleteAccountTextView ve deleteAccountButton görünmez
        deleteAccountTextView.alpha = 0
        deleteAccountButton.alpha = 0
        
        deleteAccountTextView.layer.cornerRadius = 10
        
        // Switch'in valueChanged aksiyonu ekleniyor
        deleteAccountSwitch.addTarget(self, action: #selector(deleteAccountSwitchChanged(_:)), for: .valueChanged)
        deleteAccountSwitch.isOn = false
        
        // Placeholder Label ayarları
        placeholderLabel.text = "Please explain to us in a few sentences why you deleted your account here..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.numberOfLines = 2 // Çok satırlı olmasını sağlar
        placeholderLabel.lineBreakMode = .byWordWrapping // Kelime kesme modunu ayarla
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !deleteAccountTextView.text.isEmpty
        
        // Placeholder Label boyutlandırma ve yerleşim ayarları
        placeholderLabel.frame = CGRect(x: 5, y: 5, width: deleteAccountTextView.frame.width, height: 0)
        placeholderLabel.sizeToFit() // İçeriğe göre boyutlandırma
        
        deleteAccountTextView.addSubview(placeholderLabel)
    }
    
    @objc func readButtonTapped() {
        // Create an instance of ReadMessageViewController
        let readMessageVC = PrivacySecurityMessageViewController()
        
        // Navigate to the new view controller
        self.navigationController?.pushViewController(readMessageVC, animated: true)
    }


    
    func setupPasswordToggleButtons() {
        // Mevcut şifre için toggle button
        toggleCurrentPasswordButton.addTarget(self, action: #selector(toggleCurrentPasswordVisibility), for: .touchUpInside)
        let currentPasswordRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        toggleCurrentPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        currentPasswordRightView.addSubview(toggleCurrentPasswordButton)
        currentPasswordTextField.rightView = currentPasswordRightView
        currentPasswordTextField.rightViewMode = .always
        
        // Yeni şifre için toggle button
        toggleNewPasswordButton.addTarget(self, action: #selector(toggleNewPasswordVisibility), for: .touchUpInside)
        let newPasswordRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        toggleNewPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        newPasswordRightView.addSubview(toggleNewPasswordButton)
        newPasswordTextField.rightView = newPasswordRightView
        newPasswordTextField.rightViewMode = .always
        
        // Yeni şifre onayı için toggle button
        toggleConfirmNewPasswordButton.addTarget(self, action: #selector(toggleConfirmNewPasswordVisibility), for: .touchUpInside)
        let confirmNewPasswordRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        toggleConfirmNewPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        confirmNewPasswordRightView.addSubview(toggleConfirmNewPasswordButton)
        confirmNewPasswordTextField.rightView = confirmNewPasswordRightView
        confirmNewPasswordTextField.rightViewMode = .always
    }
    
    // Klavye açıldığında sadece textView için kaydırma yapılacak
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            // Eğer sadece textView düzenleniyorsa kaydırma yapılır
            if deleteAccountTextView.isFirstResponder {
                if originalYPosition == 0 {
                    originalYPosition = self.view.frame.origin.y
                }
                
                // Navigation bar yüksekliğini al
                let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.statusBarFrame.height
                let safeAreaHeight = navBarHeight + statusBarHeight
                
                // View'ı taşırmamak için maksimum kaydırma miktarını hesapla
                let maxYPosition = originalYPosition - keyboardSize.height / 2
                
                // View'ın navigation bar altında kalmasını sağlayacak şekilde kaydırıyoruz
                self.view.frame.origin.y = max(maxYPosition, safeAreaHeight - self.view.frame.height)
            }
        }
    }
    
    // Klavye kapandığında view'i orijinal pozisyona geri getir
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != originalYPosition {
            self.view.frame.origin.y = originalYPosition
        }
    }
    
    // TextView düzenlenmeye başlandığında kaydırma aktif olur
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Klavyenin açılmasıyla ilgili ek bir işlem yapmaya gerek yok
    }
    
    @objc func deleteAccountSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UIView.animate(withDuration: 0.3) {
                self.deleteAccountTextView.alpha = 1
                self.deleteAccountButton.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.deleteAccountTextView.alpha = 0
                self.deleteAccountButton.alpha = 0
            }
        }
    }
    
    @objc func toggleCurrentPasswordVisibility() {
        currentPasswordTextField.isSecureTextEntry.toggle()
        let iconName = currentPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        toggleCurrentPasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc func toggleNewPasswordVisibility() {
        newPasswordTextField.isSecureTextEntry.toggle()
        let iconName = newPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        toggleNewPasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc func toggleConfirmNewPasswordVisibility() {
        confirmNewPasswordTextField.isSecureTextEntry.toggle()
        let iconName = confirmNewPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        toggleConfirmNewPasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc func klavyeKapat() {
        view.endEditing(true)
    }
    
    @IBAction func changePasswordButton(_ sender: Any) {
        guard let currentPassword = currentPasswordTextField.text,
              let newPassword = newPasswordTextField.text,
              let reNewPassword = confirmNewPasswordTextField.text,
              !currentPassword.isEmpty,
              !newPassword.isEmpty,
              !reNewPassword.isEmpty else {
            AlertManager.showAlert(title: "ERROR", message: "Please fill in all fields.", viewController: self)
            return
        }
        
        if newPasswordTextField.text != confirmNewPasswordTextField.text{
            AlertManager.showAlert(title: "ERROR", message: "The new passwords must match.", viewController: self)
        }
        
        guard let userEmail = currentUser?.email else {
            AlertManager.showAlert(title: "ERROR", message: "User not logged in.", viewController: self)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: currentPassword)
        
        // Kullanıcı yeniden kimlik doğrulaması
        currentUser?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                // Hata durumunu işle
                AlertManager.showAlert(title: "ERROR", message: "Reauthentication failed: \(error.localizedDescription)", viewController: self)
            } else {
                // Şifre güncellenebilir
                self.currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        // Hata durumunu işle
                        AlertManager.showAlert(title: "ERROR", message: "Password update failed: \(error.localizedDescription)", viewController: self)
                    } else {
                        // Başarılı güncelleme
                        AlertManager.showAlert(title: "SUCCESS", message: "Password updated successfully.", viewController: self)
                    }
                }
            }
        }
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "This action cannot be undone.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.saveDeleteReason()
            self.deleteUserAccount()
        }
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteUserAccount() {
        // İlk olarak Firestore'dan tüm verileri sil
        deleteUserData { [weak self] success in
            guard let self = self else { return }
            
            if success {
                // Firestore verileri başarıyla silindiyse kullanıcı hesabını sil
                self.currentUser?.delete { error in
                    if let error = error {
                        // Kullanıcı silme hatası
                        AlertManager.showAlert(title: "Error", message: "User deletion error: \(error.localizedDescription)", viewController: self)
                    } else {
                        // Kullanıcı başarıyla silindi
                        self.performSegue(withIdentifier: "toLogInVC", sender: nil)
                        AlertManager.showAlert(title: "Deleted", message: "User successfully deleted", viewController: self)
                    }
                }
            } else {
                AlertManager.showAlert(title: "Error", message: "An error occurred while deleting user data.", viewController: self)
            }
        }
    }

    func deleteUserData(completion: @escaping (Bool) -> Void) {
        guard let userEmail = currentUser?.email else {
            completion(false)
            return
        }
        
        // Kullanıcıya ait ana koleksiyonu sil
        let userCollectionRef = db.collection(userEmail)
        
        userCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                AlertManager.showAlert(title: "Error", message: "Error getting documents: \(error)", viewController: self)
                completion(false)
                return
            }
            
            let batch = self.db.batch()
            
            // Kullanıcıya ait belgeleri sil
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            // CoordinateInformations koleksiyonunu da sil
            let coordinateCollectionRef = self.db.collection(userEmail + "-CoordinateInformations")
            
            coordinateCollectionRef.getDocuments { snapshot, error in
                if let error = error {
                    AlertManager.showAlert(title: "Error", message: "Error getting CoordinateInformations documents: \(error)", viewController: self)
                    completion(false)
                    return
                }
                
                snapshot?.documents.forEach { document in
                    batch.deleteDocument(document.reference)
                }
                
                // Veritabanındaki tüm belgeler siliniyor
                batch.commit { error in
                    if let error = error {
                        print("Error deleting data: \(error)")
                        completion(false)
                    } else {
                        print("Kullanıcı verileri başarıyla silindi.")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func saveDeleteReason(){
        let uuid = UUID().uuidString
        db.collection("DeleteReasons").document(uuid).setData([
            "Reason": deleteAccountTextView.text ?? "",
            "User": currentUser?.email ?? "",
            "Date": Date()
        ]) { error in
            if let error = error {
                // Hata durumunu işle
                print("Error writing document: \(error)")
            } else {
                // Başarılı yazma
                print("Document successfully written!")
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Placeholder'ın görünürlüğünü kontrol et
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
