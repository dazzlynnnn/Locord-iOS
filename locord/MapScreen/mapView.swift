//
//  mapView.swift
//  locord
//
//  Created by 이해린 on 2021/02/20.
//

import UIKit
import NMapsMap
import SwiftyJSON
import Alamofire
import Foundation

class mapView: UIViewController {
    
    struct Location: Codable{
        let display : Int
        let mapy : Int
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    let jsconDecoder: JSONDecoder = JSONDecoder()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let x = view.center.x - 190
        let y = view.center.y - 190

        let frame = CGRect(x:x, y:y, width:380, height:380)

        let mapView = NMFMapView(frame: frame)
        let mapNaverView = NMFNaverMapView(frame: frame)

        view.addSubview(mapView)
            mapNaverView.showZoomControls = true
            mapNaverView.showLocationButton = true
            mapView.isScrollGestureEnabled = true
            mapView.isZoomGestureEnabled = true
            mapView.isTiltGestureEnabled = true
            mapView.isRotateGestureEnabled = true
            mapView.isStopGestureEnabled = true

        let marker = NMFMarker()
            marker.position = NMGLatLng(lat: 37.35931678547832, lng: 127.10479474661922)
            marker.mapView = mapView
        
    }
    
    @IBAction func touchUpSearchButton(_ sender: Any) {
        let queryValue: String = searchTextField.text!
        requestAPIToNaver(queryValue: queryValue)
    }

    
    func requestAPIToNaver(queryValue: String) {
        let headers: HTTPHeaders=[
            "X-Naver-Client-Id":"woibqApXFlygrGKGO5nZ",
            "X-Naver-Client-Secret":"bdF8QljG3z",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let url = "https://openapi.naver.com/v1/search/local.json?query=\(queryValue)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedURL)!
        
        
        AF.request(queryURL,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: headers).responseData{ response in
                    
                        debugPrint(response)
                   }
}
}
