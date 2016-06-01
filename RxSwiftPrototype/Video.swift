//
//  Video.swift
//  RxSwiftPrototype
//
//  Created by Drake Wempe on 5/31/16.
//  Copyright © 2016 Drake Wempe. All rights reserved.
//

import Foundation
import SwiftyJSON

class Video{
    
    let title : String
    
    
    init(json: JSON){
        self.title = json["metadata", "name"].string!
    }
}