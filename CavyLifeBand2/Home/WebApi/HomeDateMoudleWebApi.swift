//
//  HomeTimeLineMoudle.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy

struct HomeTimeLineMoudle: JSONJoy {
    
    var image: String
    var name: String
    var othersName: String
    var result: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do{ image = try decoder[""].getString() } catch { image = "" }
        do{ name = try decoder[""].getString() } catch { name = "" }
        do{ othersName = try decoder[""].getString()} catch { othersName = ""}
        do{ result = try decoder[""].getString()} catch { result = ""}

    }
    
}

struct HomeDateMoudle: JSONJoy {
    
    var year: Int
    var month: Int
    var day: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        do{ year = try decoder[""].getInt() } catch { year = 2016 }
        do{ month = try decoder[""].getInt() } catch { month = 1 }
        do{ day = try decoder[""].getInt()} catch { day = 1}
    }
    
}


