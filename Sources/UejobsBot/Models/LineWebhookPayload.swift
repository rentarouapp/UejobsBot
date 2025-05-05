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
    let text: String?
    var address: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
}

struct LineReplyBody: Content {
    let replyToken: String
    let messages: [LineMessage]
}
