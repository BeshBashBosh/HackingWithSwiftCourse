//
//  Move.swift
//  FourInARow
//
//  Created by Ben Hall on 26/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0 // This is used by GKModelUpdate to determine the effectiveness of a move by the GK AI
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
    
}
