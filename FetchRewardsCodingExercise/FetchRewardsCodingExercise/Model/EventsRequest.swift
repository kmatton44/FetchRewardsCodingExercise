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
    
    init() {
        let resourceString = "https://api.seatgeek.com/2/events?client_id=\(client_id)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
   
    
    // MARK: API REQUEST
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
    
    
    
    
    
}
