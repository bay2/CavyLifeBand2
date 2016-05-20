//
//  RelateAppJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct RelateAppResponse: JSONJoy {
    //通用消息头
    var commonMsg: CommenMsg
    
    //数据
    var data: GameListJson
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        data = try GameListJson(decoder["data"])
        
    }
}

struct GameListJson: JSONJoy {
    
    var gamelist = [GameJSON]()
    
    init(_ decoder: JSONDecoder) throws {
        
        if let gameArray = decoder["gamelist"].array {
            
            for game in gameArray {
                
                gamelist.append(try GameJSON(game))
                
            }
        }
    }
}

struct GameJSON: JSONJoy {
    
    var bigScreen: Int
    
    var cavyAPPHtml: String
    
    var downcount: Int
    
    var downurl: String
    
    var filesize: String
    
    var gamedesc: String
    
    var gameid: String
    
    var gamename: String
    
    var groupname: String
    
    var icon: String
    
    var packpagename: String
    
    var plistUrl: String
    
    var type: String
    
    var version: String
    
    var viewVersion: String
    
    var webicon: String
    
    
    init(_ decoder: JSONDecoder) throws {
        
        do { bigScreen = try decoder["bigScreen"].getInt() } catch { bigScreen = 1 }
        do { cavyAPPHtml = try decoder["cavyAPPHtml"].getString() } catch { cavyAPPHtml = "" }
        do { downcount = try decoder["downcount"].getInt() } catch { downcount = 1 }
        do { downurl = try decoder["downurl"].getString() } catch { downurl = "" }
        do { filesize = try decoder["filesize"].getString() } catch { filesize = "" }
        do { gamedesc = try decoder["gamedesc"].getString() } catch { gamedesc = "" }
        do { gameid = try decoder["gameid"].getString() } catch { gameid = "" }
        do { gamename = try decoder["gamename"].getString() } catch { gamename = "" }
        do { groupname = try decoder["groupname"].getString() } catch { groupname = "" }
        do { icon = try decoder["icon"].getString() } catch { icon = "" }
        do { packpagename = try decoder["packpagename"].getString() } catch { packpagename = "" }
        do { plistUrl = try decoder["plistUrl"].getString() } catch { plistUrl = "" }
        do { type = try decoder["type"].getString() } catch { type = "" }
        do { version = try decoder["version"].getString() } catch { version = "" }
        do { viewVersion = try decoder["viewVersion"].getString() } catch { viewVersion = "" }
        do { webicon = try decoder["webicon"].getString() } catch { webicon = "" }
       
        
    }
    
}
