//
//  EventTableViewCell.swift
//  FetchRewardsCodingExercise
//
//  Created by MacBook on 1/31/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventHeart: UIImageView!
    @IBOutlet weak var viewedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
