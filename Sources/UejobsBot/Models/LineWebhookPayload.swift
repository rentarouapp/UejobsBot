//
//  LineWebhookPayload.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

struct LineWebhookPayload: Content {
    let events: [LineEvent]
}

struct LineEvent: Content {
    let type: String
    let replyToken: String?
    let source: LineSource
    let message: LineMessage?
}

struct LineSource: Content {
    let type: String
    let userId: String?
}

struct LineMessage: Content {
    let type: String
    // テキスト
    var text: String? = nil
    // 位置情報
    var address: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    // Templete（画像、ボタン）
    var altText: String? = nil
    var template: LineMessageTemplate? = nil
}

struct LineMessageTemplate: Content {
    let type: String
    let thumbnailImageUrl: String?
    let title: String
    let text: String
    let actions: [LineMessageAction]
}

// MARK: - アクション（URI or Postback）
struct LineMessageAction: Content {
    let type: String
    let label: String
    let uri: String?
    let data: String?
}

struct LineReplyBody: Content {
    let replyToken: String
    let messages: [LineMessage]
}
