//
//  ViewController.swift
//  locord
//
//  Created by 이해린 on 2021/02/02.
//

import UIKit
import NMapsMap
class ViewController: UIViewController {
    
    
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
}

