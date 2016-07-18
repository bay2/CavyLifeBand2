//
//  RelateAppJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct RelateAppResponse: JSONJoy, CommenResponseProtocol {
    //通用消息头
    var commonMsg: CommenResponse
    
    //数据
    var gameList: [GameJSON]
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        gameList = [GameJSON]()
        
        if let gameArray = decoder["game_list"].array {
            
            for game in gameArray {
                
                gameList.append(try GameJSON(game))
                
            }
        }
        
    }
}

struct GameJSON: JSONJoy {
    
    var title: String
    
    var icon: String
    
    var desc: String
    
    var developer: String
    
    var type: String
    
    var appUrl: String
    
    var htmlUrl: String
    
    var updatedAt: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { title = try decoder["title"].getString() } catch { title = "" }
        do { icon = try decoder["icon"].getString() } catch { icon = "" }
        do { desc = try decoder["desc"].getString() } catch { desc = "" }
        do { developer = try decoder["developer"].getString() } catch { developer = "" }
        do { type = try decoder["type"].getString() } catch { type = "" }
        do { appUrl = try decoder["app_url"].getString() } catch { appUrl = "" }
        do { htmlUrl = try decoder["html_url"].getString() } catch { htmlUrl = "" }
        do { updatedAt = try decoder["updatedAt"].getString() } catch { updatedAt = "" }
    }
    
}
