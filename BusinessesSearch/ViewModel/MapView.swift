//
//  MapView.swift
//  BusinessesSearch
//
//  Created by Long Sen on 1/12/22.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
//    @Binding var directions: [String]
    var region: MKCoordinateRegion
//    @Binding var source: CLLocation?
    @Binding var destination: CLLocation?
    @Binding var travelTime: Double?
    @Binding var distance: Double?
//    var annotations: [MKPlacemark] = []

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

//        let region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 40.71, longitude: -74),
//            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true

        // NYC
        if let destination = destination {
//            print("user ", mapView.userLocation.coordinate)
//            print("source ", source.coordinate)
            let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude))
            print(p1.coordinate)
            let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude))
            mapView.addAnnotations([p2])

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: p1)
            request.destination = MKMapItem(placemark: p2)
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                travelTime = route.expectedTravelTime
                distance = route.distance * 0.000621371192
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                    animated: true)
            }
        }
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

