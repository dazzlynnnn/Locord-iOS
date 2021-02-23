import UIKit
import NMapsMap
class mapView: UIViewController {
    
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var title: UITextView!
    let jsconDecoder: JSONDecoder = JSONDecoder()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    class mapView: UIViewController {
            marker.mapView = mapView
        
    }
    
    @IBAction func touchUpSearchUpButton(_ sender: Any) {
        let queryValue: String = searchTextField.text!
        requestAPIToNaver(queryValue: queryValue)
    }
    
    
    func requestAPIToNaver(queryValue: String) {
        let clientID: String = "U1IE2a8BVA8xAE8f5dLI"
        let clientKEY: String = "QPiEaHzD_x"
        
        let query: String  = "https://openapi.naver.com/v1/search/local.json?query=\(queryValue)"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        var requestURL = URLRequest(url: queryURL)
                requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
                requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
                
        URLResponse
    }
}


    
    

