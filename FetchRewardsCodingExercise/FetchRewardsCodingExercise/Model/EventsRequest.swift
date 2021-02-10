//
//  EventsRequest.swift
//  FetchRewardsCodingExercise
//
//  Created by MacBook on 1/31/21.
//

import Foundation

struct EventsRequest {
    
    // MARK: Variables
    
    var resourceURL: URL
    var client_id = "MjE1MjI3ODN8MTYxMjA3Mjg4NC4zMDU0ODE3"
    
    
    // MARK: Initialization
    
    init(page: Int, numPerPage: Int, query: String) {
        // First check the query string (search box) if there are any spaces because that can mess up the api request as there can't be spaces. so repace any " " occurence with "%20"
        let newQuery = query.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let resourceString = "https://api.seatgeek.com/2/events?page=\(page)&per_page=\(numPerPage)&q=\(newQuery)&client_id=\(client_id)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
   
    
    // MARK: API REQUEST FOR EVENTS
    func getEvents (completion: @escaping(Result<[EventDetail], Error>) -> Void ) {
        
        URLSession.shared.dataTask(with: resourceURL) { data, _, error in
            
            guard let jsonData = data else {
                print("Error retrieving JSON data ")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(Initial.self, from: jsonData)
                let eventDetails = json.events
                completion(.success(eventDetails))
                
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
    
    // MARK: API REQUEST FOR META
    func getMeta (completion: @escaping(Result<MetaDetails, Error>) -> Void ) {
        
        URLSession.shared.dataTask(with: resourceURL) { data, _, error in
            
            guard let jsonData = data else {
                print("Error retrieving JSON data ")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(Initial.self, from: jsonData)
                let meta = json.meta
                completion(.success(meta))
                
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
    
    
    
    
    
}
