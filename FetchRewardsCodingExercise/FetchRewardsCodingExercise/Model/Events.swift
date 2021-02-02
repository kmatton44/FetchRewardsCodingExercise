//
//  Events.swift
//  FetchRewardsCodingExercise
//
//  Created by MacBook on 1/31/21.
//

import Foundation

struct Initial: Codable {
    var events: [EventDetail]
}

struct EventDetail: Codable {
    var type: String
    var venue: VenueInfo
    var performers: [PerformersInfo]
    var url: String //ticket url
    var title: String
    var datetime_local: String
    var id: Int
    var taxonomies: [TaxonomiesInfo]
}

struct PerformersInfo: Codable {
    var name: String
    var image: String
    var num_upcoming_events: Int
}

struct TaxonomiesInfo: Codable{
    var name: String
}

struct VenueInfo: Codable {
    var display_location: String
    var name_v2: String
    
}
