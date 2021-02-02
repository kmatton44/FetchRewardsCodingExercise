//
//  ReformatDate.swift
//  FetchRewardsCodingExercise
//
//  Created by MacBook on 2/1/21.
//

import Foundation

func reformatDate(dateString: String, withFormat format: String) -> String? {

    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy/MM/dd"

    if let date = inputFormatter.date(from: dateString) {

        let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = format

        return outputFormatter.string(from: date)
    }

    return nil
    
}

