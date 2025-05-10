//
//  LocationUtil.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

struct LocationUtil {
    // LineEventをもらって送付するLineMessageを返す
    static func lineMessage(from event: LineEvent) throws -> LineMessage {
        guard let message = event.message,
              let lat = message.latitude,
              let lon = message.longitude else {
            throw LineWebhookError.handleLineEventFailed("[message], [lat], [lon] cannot be handled")
        }
        // 仮でスタブのApple Storeを返してみる
        let store: AppleStore = .init(
            id: "1",
            name: "Apple 新宿",
            imageURL: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R128.png",
            url: "https://www.apple.com/jp/retail/shinjuku/",
            distance: 1.23
        )
        return generateLineMessageFromAppleStore(store: store)
    }
}

private extension LocationUtil {
    static func generateLineMessageFromAppleStore(store: AppleStore) -> LineMessage {
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
