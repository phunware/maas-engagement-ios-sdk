//
//  MapViewController.swift
//  EngagementSample
//
//  Created on 8/20/18.
//  Copyright © 2018 Phunware. All rights reserved.
//

import UIKit
import MapKit
import PWEngagement

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var firstLocationUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: PWMEEnterGeoZoneNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: PWMEExitGeoZoneNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: PWMEMonitoredGeoZoneChangesNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: PWMEModifyGeoZonesNotificationKey), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.mapView.removeOverlays(self.mapView.overlays)
            
            guard let geozones = PWEngagement.geozones() else {
                return
            }
            var overlaysToAdd = [MKOverlay]()
            for geozone in geozones {
                let geozoneCircle = GeozoneCircle(center: geozone.region.center, radius: geozone.region.radius)
                geozoneCircle.title = geozone.name
                if geozone.inside {
                    geozoneCircle.geozoneStatus = .inside
                } else {
                    geozoneCircle.geozoneStatus = .outside
                }
                if !geozone.monitored {
                    geozoneCircle.geozoneStatus = .unmonitored
                }
                overlaysToAdd.append(geozoneCircle)
            }
            
            self.mapView.addOverlays(overlaysToAdd)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let geozoneCircle = overlay as? GeozoneCircle else {
            return MKOverlayRenderer()
        }
        
        let circleRenderer = MKCircleRenderer(circle: geozoneCircle)
        circleRenderer.lineWidth = 2.0
        switch geozoneCircle.geozoneStatus {
        case .inside:
            circleRenderer.fillColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 0.3)
            circleRenderer.strokeColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        case .outside:
            circleRenderer.fillColor = (UIColor.blue).withAlphaComponent(0.3)
            circleRenderer.strokeColor = .blue
        case .unmonitored:
            circleRenderer.fillColor = (UIColor.gray).withAlphaComponent(0.3)
            circleRenderer.strokeColor = .gray
        }
        
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !firstLocationUpdate {
            firstLocationUpdate = true
            let camera = MKMapCamera(lookingAtCenter: userLocation.coordinate, fromEyeCoordinate: userLocation.coordinate, eyeAltitude: 800.0)
            mapView.setCamera(camera, animated: false)
        }
    }
}
