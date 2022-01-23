//
//  BusinessesSearch.swift
//  BusinessesSearch
//
//  Created by Long Sen on 12/30/21.
//

import Combine
import CoreLocation
import MapKit
import SwiftUI


class BusinessesSearch: ObservableObject {
    
    @Published var businesses: [Businesses.Business] = []
    @Published var searchingHistoryBusinesses: [Businesses.Business] = []
    @Published var isFetching = false
    
    @Published var index: Int = -1 {
        didSet {
            updateLocation()
        }
    }
    
    @Published var isEmpty = false
    
    private let apiKey = "xFvjWTjrtfmEVWqqIpn-xbJerOUnrAOzsbm1WHpOHlHlAMmk_iMafif_FdZvzwD4WIYLFCTNAEYTG2kC7Uisa7WD44SkDOcw7sobxdsNH2T7GGrMTwSuIn8YifLMYXYx"
    
    func createBusinessesURL(term: String, latitude: String, longitude: String) -> String {
        "https://api.yelp.com/v3/businesses/search?term=\(term)&latitude=\(latitude)&longitude=\(longitude)"
    }
    
    func createBusinessesURL(term: String, location: String) -> String {
        "https://api.yelp.com/v3/businesses/search?term=\(term)&location=\(location)"
    }
    
    func createBusinessDetailRequest(id: String) -> String {
        "https://api.yelp.com/v3/businesses/\(id)"
    }
    
    func createReviewsURL(id: String) -> String {
        "https://api.yelp.com/v3/businesses/\(id)/reviews"
    }
    
    func createRequest(with url: String) -> URLRequest {
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private var cancellable: AnyCancellable?

    func fetchBusinesses(term: String, searchLocation: String) {
        saveKeywordAndLocation(keyword: term, location: searchLocation)
        if self.currentLocation == nil {
            fetchLocation()
        }
        let termWithoutSpace = term.replacingOccurrences(of: " ", with: "")
        let url: String
        if searchLocation == "Current Location" {
            guard self.currentLocation != nil else { return }
            url =  createBusinessesURL(term: termWithoutSpace, latitude: String(currentLocation!.coordinate.latitude), longitude: String(currentLocation!.coordinate.longitude))
        } else {
            let searchLocationWithoutSpace = searchLocation.replacingOccurrences(of: " ", with: "")
            url = createBusinessesURL(term: termWithoutSpace, location: searchLocationWithoutSpace)
        }
        let request = createRequest(with: url)
        self.isFetching = true
        self.businesses = []
        self.cancellable =  URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: Businesses.self, decoder: JSONDecoder())
            .map(\.businesses)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }, receiveValue: { businesses in
                if businesses.count > 0 {
                    self.isEmpty = false
                    self.businesses = businesses
                    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: businesses[0].coordinate.latitude, longitude: businesses[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                } else {
                    self.isEmpty = true
                }
                self.isFetching = false
            })
    }
    
    @Published var businessDetail: Businesses.Business?
    func fetchBusinessDetail(for id: String) {
        guard let index = businesses.firstIndex(where: { $0.id == id }) else { return }
        self.destination = CLLocation(latitude: businesses[index].coordinate.latitude, longitude: businesses[index].coordinate.longitude)
        businessDetail = businesses[index]
        if businessDetail?.photos == nil {
            let url =  createBusinessDetailRequest(id: id)
            let request = createRequest(with: url)
            self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw HTTPError.statusCode
                    }
                    return output.data
                }
                .decode(type: Businesses.Business.self, decoder: JSONDecoder())
//                .map(\.businesses)
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }, receiveValue: { business in
                    self.businesses[index] = business
                    self.businessDetail = business
                    if self.searchingHistoryBusinesses.count == 20 {
                        self.searchingHistoryBusinesses.removeLast()
                    }
                    self.searchingHistoryBusinesses.insert(business, at: 0)
                })
        }
    }
    
    @Published var reviews: [Reviews.Review] = []
    func fetchBusinessReviews(for id: String) -> AnyPublisher<[Reviews.Review], Error> {
        let url =  createReviewsURL(id: id)
        let request = createRequest(with: url)
        //        self.cancellable =
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: Reviews.self, decoder: JSONDecoder())
            .map(\.reviews)
//            .replaceError(with: [])
            .eraseToAnyPublisher()
        
        //            .receive(on: DispatchQueue.main)
        //            .sink(receiveCompletion: { completion in
        //                switch completion {
        //                case .finished:
        //                    break
        //                case .failure(let error):
        //                    fatalError(error.localizedDescription)
        //                }
        //            }, receiveValue: { reviews in
        //                self.reviews = reviews
        //                print(self.reviews)
        //            })
    }
    
//        func fetchBusiness(for id: String) {
//            guard let index = businesses.firstIndex(where: { $0.id == id }) else { return }
//            self.destination = CLLocation(latitude: businesses[index].coordinate.latitude, longitude: businesses[index].coordinate.longitude)
//            businessDetail = businesses[index]
//            if businessDetail?.photos == nil {
//                cancellable = fetchBusinessDetail(for: id)
//                    .zip(fetchBusinessReviews(for: id))
//                    .eraseToAnyPublisher()
//                    .receive(on: DispatchQueue.main)
//                    .sink(receiveCompletion: { completion in
//                        switch completion {
//                        case .finished:
//                            break
//                        case .failure(let error):
//                            fatalError(error.localizedDescription)
//                        }
//                    }, receiveValue: { (business, reviews) in
//                        self.objectWillChange.send()
//                        self.businesses[index] = business
//                        self.businessDetail = business
//                        self.reviews = reviews
//                    })
//            }
//        }
    @Published private(set) var historyKeywords: [String] = []
    @Published private(set) var historyLocation: [String] = []
    
    private func saveKeywordAndLocation(keyword: String, location: String) {
        if !historyKeywords.contains(keyword) {
            historyKeywords.insert(keyword, at: 0)
        }
        if !historyLocation.contains(location) && location != "Current Location" {
            historyLocation.insert(location, at: 0)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let locationService = LocationService()
    
//    @Published private(set) var isLoading = false
    @Published var currentLocation: CLLocation?
    @Published private(set) var locationError: LocationError?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    @Published var destination: CLLocation?
    
    func fetchLocation() {
//        isLoading = true
        locationService.requestWhenInUseAuthorization()
            .flatMap { self.locationService.requestLocation() }
            .sink { completion in
                if case .failure(let error) = completion {
                    self.locationError = error
                }
//                self.isLoading = false
            } receiveValue: { location in
                self.currentLocation = location
//                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            }
            .store(in: &cancellables)
    }
    
    func updateLocation() {
        let businessCoordinates = self.businesses[index].coordinates
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: businessCoordinates.latitude, longitude: businessCoordinates.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
}

enum HTTPError: LocalizedError {
    case statusCode
}

enum SearchPageAction {
    case none
    case show
    case search
}
