import UIKit

class ShowCoordinateViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var isGoneSwitch: UISwitch!
    @IBOutlet weak var coordinateVisibiltySwitch: UISwitch!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    var uuid: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.text = uuid
    }

}
