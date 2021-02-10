//
//  ViewController.swift
//  FetchRewardsCodingExercise
//
//  Created by MacBook on 1/31/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: Outlets & Variables
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
    let defaults = UserDefaults.standard
    
    
    var totalEvents: Int?
    var totalPages: Int = 1
    var page = 1
    var perPage = 10
    var query = ""
    
    var dataMeta = MetaDetails()
    var filteredData = [EventDetail]()
    var listOfEvents = [EventDetail]() {
        // Property observer to listen for changes in events
        //
        // This is where I am going to deal with changes in liked events as well updating table view.
        //
        // I am going to save liked events through their IDs locally, and because there are only 10 events at a time
        // We won't be using as much data because if there is a change in events, we will reset the data stored back to an empty list
        didSet {
            DispatchQueue.main.async {
                // if there was a change in data, reset eventsLiked local defaults variable
                self.defaults.set([], forKey: "eventsLiked")
                // Reload table view and layout
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                
            }
        }
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventRequest(page: page, numPerPage: perPage, query: query)
        metaRequest()
        setTableView()
        print()
    }
    
    // MARK: Functions
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    func eventRequest(page: Int, numPerPage: Int, query: String) {
        let eventRequest = EventsRequest(page: page, numPerPage: numPerPage, query: query)
        eventRequest.getEvents { [weak self] result in
            
            switch result {
        
            case .failure(let error):
                print(error)
            case .success(let events):
                self?.listOfEvents = events
                self?.filteredData += self!.listOfEvents
                
            }
        }
    }
    
    func metaRequest() {
        let metaRequest = EventsRequest(page: page, numPerPage: perPage, query: query)
        metaRequest.getMeta { [weak self] result in
            
            switch result {
        
            case .failure(let error):
                print(error)
            case .success(let meta):
                self?.dataMeta = meta
                self?.totalEvents = self?.dataMeta.total
                self?.totalPages = (self?.totalEvents)!/(self?.perPage)!
                //self?.filteredData = self!.listOfEvents
            }
        }
    }
    
    @IBAction func loadMoreClicked(_ sender: UIButton) {
        // Update page number
        page += 1
        
        // Meta request to get total number of pages
        metaRequest()
        totalEvents = dataMeta.total
        totalPages = totalEvents!/perPage
        
        // Only event request if page is less than or equal to total pages in api. else dont do anything
        if page <= totalPages {
            eventRequest(page: page, numPerPage: perPage, query: query)
        }
        
    }
    
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "eventInfo" {
            let indexPath = tableView.indexPathForSelectedRow!
            let event = filteredData[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let eventInfoViewController = navController.topViewController as! EventInfoViewController
            
            eventInfoViewController.event = event
            
        }
        
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }

}

// MARK: Table View Setup

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell
        let loadMoreCell = tableView.dequeueReusableCell(withIdentifier: "loadMoreCell", for: indexPath) as? LoadMoreTableViewCell
        
        if indexPath.item == filteredData.count{
        
            return loadMoreCell!
        }
        
        else {
            
            // Event Name
            let eventName = filteredData[indexPath.row].title
            
            // Event Image
            let eventImageURL = filteredData[indexPath.row].performers[0].image

            if let url = URL(string: eventImageURL) {
                if let data = try? Data(contentsOf: url) {
                    cell?.eventImage.contentMode = .scaleToFill
                    cell?.eventImage.image = UIImage(data: data)
                    cell?.eventImage.layer.cornerRadius = 10
                }
            }
            
                   
            // Event Location
            let eventLocation = filteredData[indexPath.row].venue.display_location
            
            // Event Date and Time
            let dateAndTime = filteredData[indexPath.row].datetime_local
            let date = dateAndTime.prefix(10)
            let time = dateAndTime.suffix(8)
            let dateFormatted = reformatDate(dateString: "\(date)", withFormat: "MMM-dd-yyyy")
            
            
            // Event Heart Image
            let likedEvents = defaults.object(forKey: "likedEvents") as? [Int] ?? []
            if likedEvents.contains(filteredData[indexPath.row].id) {
                cell?.eventHeart.isHidden = false
            } else {
                cell?.eventHeart.isHidden = true
            }
            
            // Event Viewed Label
            let viewedEvents = defaults.object(forKey: "viewedEvents") as? [Int] ?? []
            if viewedEvents.contains(filteredData[indexPath.row].id) {
                cell?.viewedLabel.alpha = 0.5
            } else {
                cell?.viewedLabel.alpha = 0
            }

            // Set the objects to their respected data values
            cell?.eventDate.text = dateFormatted! + " " + time
            cell?.eventLocation.text = eventLocation
            cell?.eventName.text = eventName
            
        
            return cell!
        }
    }
    
    
    
    
}

// MARK: Search Bar Set Up

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Reset the filter when text changes
        filteredData = []
        
        // If the search box is empty, the filtered data should be set to the full list of events
        if searchText == "" {
            // If search box is empty, reset the table view to the first page
            listOfEvents = []
            filteredData = []
            eventRequest(page: 1, numPerPage: perPage, query: "")
            filteredData = listOfEvents
            
        }
        
        else {
            // Get query text
            query = searchText
            
            // Grab meta data
            metaRequest()
            totalEvents = dataMeta.total
            totalPages = totalEvents!/perPage
            
            // Event request
            eventRequest(page: page, numPerPage: perPage, query: query)
        
        }
        
        
        tableView.reloadData()
    }
}

