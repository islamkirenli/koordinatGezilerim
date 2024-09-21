import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfilAccountViewController: UIViewController {

    @IBOutlet weak var profilPhotoImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    let currentUser = Auth.auth().currentUser
    let firestoreDB = Firestore.firestore()

    var avatarName = "avatar-1"

    override func viewDidLoad() {
        super.viewDidLoad()

        if currentUser != nil{
            emailLabel.text = currentUser?.email
        }else{
            print("email bulunamadı.")
        }
        
        let placeholderTextName = "Name"
        let placeholderColor = UIColor.gray
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderTextName,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        let placeholderTextSurname = "Surname"
        surnameTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderTextSurname,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectAvatar))
        profilPhotoImageView.isUserInteractionEnabled = true
        profilPhotoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        firebaseVerileriAl()
    }
    
    @objc func selectAvatar() {
        let avatarVC = AvatarSelectionViewController()
        avatarVC.selectedAvatar = { [weak self] avatarName in
            self?.profilPhotoImageView.image = UIImage(named: avatarName)
            self?.avatarName = avatarName // Seçilen avatarı sakla
        }
        present(avatarVC, animated: true, completion: nil)
    }

    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }

    @IBAction func saveButton(_ sender: Any) {
        firestoreDB.collection("user").document("profilSettings").setData([
            "name": nameTextField.text ?? "",
            "surname": surnameTextField.text ?? "",
            "email": currentUser?.email,
            "avatar": self.avatarName,
        ]) { error in
            if let error = error {
                // Hata durumunu işle
                print("Error writing document: \(error)")
            } else {
                // Başarılı yazma
                //Alerts.showAlert(title: "Saved!", message: "Your information has been successfully saved.", viewController: self)
                print("Document successfully written!")
            }
        }
    }
    
    func firebaseVerileriAl(){
        let coordinateDocRef = firestoreDB.collection("user").document("profilSettings")
        coordinateDocRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let avatarID = data?["avatar"] as? String{
                    self?.profilPhotoImageView.image = UIImage(named: avatarID)
                    self?.avatarName = avatarID
                }
                if let name = data?["name"] as? String{
                    self?.nameTextField.text = name
                }
                
                if let surname = data?["surname"] as? String{
                    self?.surnameTextField.text = surname
                }
            } else {
                print("Profil document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
