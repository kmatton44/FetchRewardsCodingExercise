//
//  EventInfoViewController.swift
//  FetchRewardsCodingExercise
//
//  Created by MacBook on 2/1/21.
//

import UIKit

class EventInfoViewController: UIViewController {
    
    // MARK: Outlets and Variables
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventLikeButton: UIButton!
    
    let defaults = UserDefaults.standard
    var event: EventDetail?
    var eventLiked: Bool?
    
    //Using Event IDs to save likes and viewings
    var likedEvents: [Int]?
    var viewedEvents: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateHeartButton()
        updateEventObjects()
        
    }
    
    // MARK: Functions
    
    func updateEventObjects() {
        //Event Name
        eventName.text = event?.title
        
        //Event Image
        let eventImageURL = event?.performers[0].image
        if let url = URL(string: eventImageURL!) {
            if let data = try? Data(contentsOf: url) {
                eventImage.contentMode = .scaleToFill
                eventImage.image = UIImage(data: data)
                eventImage.layer.cornerRadius = 10
            }
        }
        
        // Event Location
        eventLocation.text = event?.venue.display_location
        
        // Event Date and Time
        let dateAndTime = event!.datetime_local
        let date = dateAndTime.prefix(10)
        let time = dateAndTime.suffix(8)
        let dateFormatted = reformatDate(dateString: "\(date)", withFormat: "MMM-dd-yyyy")
        eventTime.text = dateFormatted! + " " + time
        
        // Update viewed Events list with new event ID and save it into user defaults
        viewedEvents = defaults.object(forKey: "viewedEvents") as? [Int] ?? []
        if !viewedEvents!.contains(event!.id) {
            viewedEvents?.append(event!.id)
        }
        defaults.set(viewedEvents, forKey: "viewedEvents")
        
    }
    
    func updateHeartButton() {
        
        guard let event = event else {return}
        // Grab liked events to update eventLikedHeart
        likedEvents = defaults.object(forKey: "likedEvents") as? [Int] ?? []
        
        // Update eventLikedButton Heart (On or Off)
        eventLiked = likedEvents?.contains(event.id)
        
        if eventLiked! {
            eventLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            eventLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
    // MARK: Button Actions
    
    @IBAction func eventLikedPressed(_ sender: UIButton) {
       
        // If button pressed and event is liked, append it to liked events, then save it
        if eventLiked! { // if true
            likedEvents?.removeAll(where: { $0 == event?.id })
            defaults.set(likedEvents, forKey: "likedEvents")
        }
        // If button pressed and event is disliked, remove it from liked events and save it
        else { // if false
            likedEvents?.append(event!.id)
            defaults.set(likedEvents, forKey: "likedEvents")
        }
        
        updateHeartButton()
        
    }
    

}
