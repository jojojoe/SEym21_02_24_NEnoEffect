//
//  NEEDataM.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/18.
//

import UIKit

class NEEDataM {
    var borderList_16_9: [NEymEditToolItem] = []
    var borderList_1_1: [NEymEditToolItem] = []
    var bgColorList: [NEymEditToolItem] = []
    var stickerItemList_animal: [NEymEditToolItem] = []
    var stickerItemList_mark: [NEymEditToolItem] = []
    var stickerItemList_plant: [NEymEditToolItem] = []
    var stickerItemList_word: [NEymEditToolItem] = []
    
    
    static let `default` = NEEDataM()
    
    init() {
        loadData()
    }
    
    func loadData() {
        borderList_16_9 = loadJson([NEymEditToolItem].self, name: "border169") ?? []
        borderList_1_1 = loadJson([NEymEditToolItem].self, name: "border11") ?? []
        bgColorList = loadJson([NEymEditToolItem].self, name: "bgcolor") ?? []
        stickerItemList_animal = loadJson([NEymEditToolItem].self, name: "sticker_ani") ?? []
        stickerItemList_mark = loadJson([NEymEditToolItem].self, name: "sticker_mark") ?? []
        
        stickerItemList_word = loadJson([NEymEditToolItem].self, name: "sticker_word") ?? []
        stickerItemList_plant = loadJson([NEymEditToolItem].self, name: "sticker_plant") ?? []
        
        
    }
    var paintStyleItemList: [GCPaintItem] {
        let list = loadPlist([GCPaintItem].self, name: "GCPaintStyleList") ?? []
        
        return list.reversed()
    }
    
}


extension NEEDataM {
    func loadJson<T: Codable>(_:T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



struct NEymEditToolItem: Codable, Hashable {
    static func == (lhs: NEymEditToolItem, rhs: NEymEditToolItem) -> Bool {
        return lhs.thumbName == rhs.thumbName
    }
    var thumbName: String = ""
    var bigName: String = ""
    var isPro: Bool = false
     
}

class GCPaintItem: Codable {
    let previewImageName : String
    let StrokeType : String
    let gradualColorOne : String
    let gradualColorTwo : String
    let isDashLine : Bool
    
    
}

//
//
//struct ShapeItem: Codable, Identifiable, Hashable {
//    static func == (lhs: ShapeItem, rhs: ShapeItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct StickerItem: Codable, Identifiable, Hashable {
//    static func == (lhs: StickerItem, rhs: StickerItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct BackgroundItem: Codable, Identifiable, Hashable {
//    static func == (lhs: BackgroundItem, rhs: BackgroundItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//
