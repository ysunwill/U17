//
//  API.swift
//  U17
//
//  Created by ysunwill on 2022/3/24.
//

import Moya
import CodableWrapper
import MBProgressHUD
import Result
import Dispatch

let LoadingPlugin = NetworkActivityPlugin { (type, target) in
//    DispatchQueue.main.async {
        guard let vc = topVC else { return }
        switch type {
        case .began:
            MBProgressHUD.hide(for: vc.view, animated: false)
            MBProgressHUD.showAdded(to: vc.view, animated: true)
        case .ended:
            MBProgressHUD.hide(for: vc.view, animated: true)

        }
//    }
    
    
}

let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<Api>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let ApiProvider = MoyaProvider<Api>(requestClosure: timeoutClosure)
let ApiLoadingProvider = MoyaProvider<Api>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

enum Api {
    
    // 发现（顶部分类，更新、漫画、每日领奖...）
    case findCategory
    // 发现 --> 漫画
    case findComic
    // 漫画介绍
    case comicIntro(comicid: Int)
    // 漫画所有章节
    case comicChapterList(comicid: Int)
    //章节内容
    case chapter(chapter_id: String?)
    // 我的收藏
    case myFav
    // 我的书单
    case myBookList
    // 阅读历史
    case readHistory
    // 漫画详情 --> 社区评论
    case comicCommunity(comicid: Int)
    
}

extension Api: TargetType {
    static let userKey: String = "自己的账号产生的KEY"
    
    var baseURL: URL { return URL(string: "https://app.u17.com/v3/appV3_3/ios/phone")! }
    
    var path: String {
        switch self {
        case .findCategory: return "Recommend/head"
        case .findComic: return "comic/getDetectListV4_5"
        case .comicIntro: return "comic/detail_simple_dynamic"
        case .comicChapterList: return "comic/getDetailChapterList"
        case .chapter: return "comic/chapterNew"
        case .comicCommunity : return "community/comicCommunity"
        case .myFav: return "fav/index"
        case .myBookList: return "fav/group"
        case .readHistory: return "read/readhistory"

        }
    }
    
    var method: Moya.Method { return .get }
    var task: Task {
        var parmeters: [String : Any] = [:]
        switch self {
        case .comicIntro(let comicid):
            parmeters["comicid"] = comicid
            parmeters["version"] = "5.8.3"
        case .comicChapterList(let comicid):
            parmeters["comicid"] = comicid
            parmeters["version"] = "5.8.3"
        case .chapter(let chapter_id):
            parmeters["chapter_id"] = chapter_id
        case .comicCommunity(let comicid):
            parmeters["comic_id"] = comicid
            parmeters["version"] = "5.8.3"
        case .myFav , .myBookList , .readHistory:
            parmeters["key"] = Api.userKey
        default:
            break
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
    var headers: [String : String]? { return nil }
}


extension Response {
    func mapModel<T: Codable>(_ type: T.Type) throws -> T {
        guard let model = try? JSONDecoder().decode(type, from: data) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

extension MoyaProvider {
    @discardableResult
    open func request<T: Codable>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {

        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(returnData.data?.returnData)
        })
    }
}

