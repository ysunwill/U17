//
//  Model.swift
//  U17
//
//  Created by ysunwill on 2022/3/24.
//

import CodableWrapper

struct ReturnData<T: Codable>: Codable {
    var message:String?
    var returnData: T?
    var stateCode: Int = 0
}

struct ResponseData<T: Codable>: Codable {
    var code: Int = 0
    var data: ReturnData<T>?
}

/// 发现，顶部分类
struct FindCategoryItem: Codable {
    @Codec var title: String!
}

/**
enum FindComicModuleTpye: Int {
    case regular = 1  // 普通
    case hh           // 广告等（横向，或可滑动）
    case unknown      // 未知（暂不处理）
    case hv           // 动画影视（横向，或可滑动）
}

enum FindComicUIType: Int {
    case fourItems = 1 // 四个，二等分
    case fiveItems = 4 // 五个，一大四小
    case sixItems  = 3 // 六个，三等分
    case unknown   = 0
}
*/

/// 发现 --> 漫画

struct FindComicEntity: Codable {
    @Codec var defaultSearch: String = ""
    @Codec var galleryItems: [GalleryItem] = []
    @Codec var modules: [FindComicModule] = []
}

struct GalleryItem: Codable {
    @Codec var id: Int = 0
    @Codec var ext: [Ext] = []
    @Codec var topCover: String = ""
    @Codec var linkType: Int = 0
    @Codec var cover: String = ""
    @Codec var title: String = ""
}

struct Ext: Codable {
    @Codec var key: String?
    @Codec var val: Int = 0
}

struct FindComicModule: Codable {
    var moduleInfo: FindComicModuleInfo?
    var items: [[FindComicModuleItem]] = []
    var moduleType: Int = 0
    var uiType: Int = 0
    
    // 1
    enum CodingKeys: String, CodingKey {
        case moduleInfo = "moduleInfo"
        case items = "items"
        case moduleType = "moduleType"
        case uiType = "uiType"
    }
   
    // 解码: JSON 转 Model
    init(from decoder: Decoder) throws {
        // 2
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 3
        moduleInfo = try container.decode(FindComicModuleInfo.self, forKey: .moduleInfo)
        moduleType = try container.decode(Int.self, forKey: .moduleType)
        uiType = try container.decode(Int.self, forKey: .uiType)
        if let dicItems = try? container.decode([FindComicModuleItem].self, forKey: .items) {
            items = [dicItems]
        } else {
            items = try container.decode([[FindComicModuleItem]].self, forKey: .items)
        }
    }
   
    // 编码: Model 转 JSON
    func encode(to encoder: Encoder) throws {
        // 4
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(moduleInfo, forKey: .moduleInfo)
        try container.encode(moduleType, forKey: .moduleType)
        try container.encode(uiType, forKey: .uiType)
        try container.encode(items, forKey: .items)
    }
}

struct FindComicModuleInfo: Codable {
    @Codec var argName: String = ""
    @Codec var argValue: Int = 0
    @Codec var title: String = ""
    @Codec var bgCover: String = ""
}

struct FindComicModuleItem: Codable {
    @Codec var comicId: Int?
    @Codec var title: String = ""
    @Codec var cover: String = ""
    @Codec var subTitle: String = ""
    @Codec var ext: [Ext] = []
}


/// 发现 --> 漫画列表 --> 漫画详情

struct ComicInfoEntity: Codable {
    @Codec var comment: ComicInfoComment?
    @Codec var comic: ComicSummary?
    @Codec var chapter_list: [ChapterListItem] = []
}

struct ComicSummary: Codable {
    @Codec var name: String = ""
    @Codec var description: String = ""
    @Codec var theme_ids: [String]?
    @Codec var click_total: String = ""
    @Codec var favorite_total: Int = 0
    @Codec var author: ComicAuthor?
    @Codec var cover: String = ""
    @Codec var wideCover: String = ""
    @Codec var wideColor: String?
    @Codec var is_free: Bool = false
    @Codec var series_status: Bool = false // 是否连载
    @Codec var pass_chapter_num: Int = 0
    @Codec var affiche: String = ""
}

struct ComicAuthor: Codable {
    @Codec var avatar: String = ""
    @Codec var name: String = ""
}

struct ComicInfoComment: Codable {
    @Codec var commentList: [ComicInfoCommentItem]?
    @Codec var commentCount: Int?
}

struct ComicInfoCommentItem: Codable {
    @Codec var content: String = ""
    @Codec var create_time_str: String = ""
    @Codec var is_choice: Bool = false
    @Codec var user: User?
    @Codec var total_reply: Int = 0
    @Codec var praise_total: Int = 0
}

struct User: Codable {
    @Codec var face: String = ""
    @Codec var nickname: String = ""
}


/// 发现 --> 漫画列表 --> 漫画章节

struct ComicChapterEntity: Codable {
    @Codec var chapter_list: [ChapterListItem]?
    @Codec var ticket: ChapterTicket?
}

struct ChapterListItem: Codable {
    @Codec var name: String = ""
    @Codec var smallPlaceCover: String = ""
    @Codec var publish_time: TimeInterval = 0
    @Codec var chapterIndex: Int = 0
}

struct ChapterTicket: Codable {
    @Codec var ticketRank: [ChapterTicketRank]?
    @Codec var comicTicket: ChapterComicTicket?
}

struct ChapterTicketRank: Codable {
    @Codec var face: String = ""
    @Codec var rank: Int = 0
}

struct ChapterComicTicket: Codable {
    @Codec var rank: String?
}

/// 发现 --> 漫画列表 --> 漫画详情 --> 漫画社区

struct ComicInfoCommunityEntity: Codable {
    @Codec var communityList: [CommunityListItem]?
    @Codec var communityTotal: Int?
}

struct CommunityListItem: Codable {
    @Codec var content: String = ""
    @Codec var title: String = ""
    @Codec var create_time_str: String = ""
    @Codec var user: User?
    @Codec var total_reply: Int = 0
    @Codec var praise_total: Int = 0
}
