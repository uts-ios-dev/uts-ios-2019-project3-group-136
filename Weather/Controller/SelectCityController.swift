

import UIKit


protocol SelectCityDelegate {
    func didChangeCity(city:String)
}

class SelectCityController: UIViewController {

    var currentCity = ""
    
    var delegate:SelectCityDelegate?
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var cityInput: UITextField!
    
    
    @IBAction func changeCity(_ sender: Any) {
        
        delegate?.didChangeCity(city: cityInput.text!)
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCityLabel.text = currentCity
        // Do any additional setup after loading the view.
    }
    



}
