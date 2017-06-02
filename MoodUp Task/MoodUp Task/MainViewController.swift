import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import AlamofireImage

class MainViewController: UIViewController {
    
    // MARK: Properties
    
    // Global variables
    struct GlobalVariable {
        static var name = ""
        static var profileImageURL = ""
    }
    
    
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var loginBox: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuButtonConstraint: NSLayoutConstraint!
    var alertController: UIAlertController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil {
            getFBData()
        }
        
        setUI()
        setActionSheet()
    }
    
    
    // MARK: Functions
    
    func getFBData() {
        let params = ["fields": "name, picture"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    self.loginLabel.text = "Logged as \(responseDictionary["name"] as! String)"
                    GlobalVariable.name = responseDictionary["name"] as! String
                    GlobalVariable.profileImageURL = (((responseDictionary["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String)!
                    self.getImage(imageURL: GlobalVariable.profileImageURL, imageView: self.profileImage)
                }
            }
        }
    }

    func setUI() {
        // Round image
        let imageRadius: CGFloat = #imageLiteral(resourceName: "centerImage").size.width/2
        centerImage.layer.cornerRadius = imageRadius
        
        // FBData Box
        if AccessToken.current != nil {
            loginBox.isHidden = false
        }
        else {
            menuButtonConstraint.constant = menuButtonConstraint.constant - loginBox.bounds.height
        }
    }
    
    func setActionSheet() {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let getRecipeAction = UIAlertAction(title: "Get the Recipe", style: .default) { (action) -> Void in
            self.navigationController?.pushViewController(RecipeViewController(), animated: true)
        }
        alertController.addAction(getRecipeAction)
        
        if AccessToken.current == nil {
            let logInFbAction = UIAlertAction(title: "Zaloguj przez Facebooka", style: .default) { (action) -> Void in
                self.loginButtonClicked()
            }
            alertController.addAction(logInFbAction)
        }
        else {
            let logOutFbAction = UIAlertAction(title: "Wyloguj", style: .default) { (action) -> Void in
                LoginManager().logOut()
                self.loginBox.isHidden = true
                self.menuButtonConstraint.constant = self.menuButtonConstraint.constant - self.loginBox.bounds.height
                self.setActionSheet()
            }
            alertController.addAction(logOutFbAction)
        }
        
        let closeMenuAction = UIAlertAction(title: "Ukryj menu", style: .cancel, handler: nil)
        alertController.addAction(closeMenuAction)
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success:
                self.getFBData()
                self.loginBox.isHidden = false
                self.menuButtonConstraint.constant = self.menuButtonConstraint.constant + self.loginBox.bounds.height
                self.setActionSheet()
            }
        }
    }
    
    func getImage(imageURL: String, imageView: UIImageView) {
        Alamofire.request(imageURL).responseImage { response in
            
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
}
