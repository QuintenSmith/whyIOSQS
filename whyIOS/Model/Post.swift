//
//  Post.swift
//  whyIOS
//
//  Created by Quinten Smith on 9/5/18.
//  Copyright © 2018 Quinten Smith. All rights reserved.
//

import Foundation

struct Post: Codable {
    let name: String
    let reason: String
    let uuid: String = UUID().uuidString
    let cohort: String = "iOS21"
}


