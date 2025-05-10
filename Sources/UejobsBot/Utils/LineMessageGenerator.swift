//
//  LineMessageGenerator.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/09.
//

import Vapor

enum ReceiveMessageType: String {
    case text = "text"
    case location = "location"
}

struct LineMessageGenerator {
    static func lineMessage(req: Request) throws -> LineMessage {
        let body = try req.content.decode(LineWebhookPayload.self)
        guard let event = body.events.first else {
            throw LineWebhookError.payloadEventIsEmpty
        }
        guard let message = event.message else {
            throw LineWebhookError.lineEventMessageIsNil
        }
        switch message.type {
        case "text":
            // テキストメッセージが送られた
            return try TextUtil.lineMessage(from: event)
        case "location":
            // 場所情報が送られた
            return try LocationUtil.lineMessage(from: event)
        default:
            throw LineWebhookError.lineReceiveMessageTypeNotMatch(message.type)
        }
    }
}
