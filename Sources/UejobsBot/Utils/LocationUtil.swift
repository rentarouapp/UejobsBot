//
//  LocationUtil.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

enum LocationUtil {
    // AppleStoreをもらって最終的なLineMessageを返す
    static func lineMessageFromLocationTypeEvent(event: LineEvent) -> LineMessage? {
        guard let message = event.message,
              let lat = message.latitude,
              let lon = message.longitude,
              let replyToken = event.replyToken else {
            print("⚠️ lineMessageFromLocationTypeEvent Failed.")
            return nil
        }
        // 仮でスタブのApple Storeを返してみる
        let store: AppleStore = .init(
            id: "1",
            name: "Apple 新宿",
            imageURL: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R128.png",
            url: "https://www.apple.com/jp/retail/shinjuku/",
            distance: 1.23
        )
        return lineMessageFromAppleStore(store: store)
    }
}

private extension LocationUtil {
    static func lineMessageFromAppleStore(store: AppleStore) -> LineMessage {
        let lineMessageActions = [
            LineMessageAction(type: "uri", label: "サイトを見る", uri: store.url, data: nil),
            LineMessageAction(type: "postback", label: "場所を見る", uri: nil, data: "store_\(store.id)")
        ]
        let template = LineMessageTemplate(
            type: "buttons",
            thumbnailImageUrl: store.imageURL,
            title: store.name,
            text: "いちばん近いのは【\(store.name)】\n距離: \(String(format: "%.2f", store.distance))km",
            actions: lineMessageActions
        )
        let lineMessage = LineMessage(
            type: "template",
            altText: "おすすめのApple Storeを表示します",
            template: template
        )
        return lineMessage
    }
}
