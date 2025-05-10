//
//  LineWebhookError.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/10.
//

import Foundation

enum LineWebhookError: Error {
    case payloadEventIsEmpty
    case lineEventMessageIsNil
    case lineReceiveMessageTypeNotMatch(String)
    case replyTokenNotFound
    case generateLineMessageFailed(ReceiveMessageType)
    case replyLineMessageFailed(NSError)
    case handleLineEventFailed(String)
    
    var localizedDescription: String {
        switch self {
        case .payloadEventIsEmpty:
            return "⚠️ Event is empty..."
        case .lineEventMessageIsNil:
            return "⚠️ Received, but ['message'] is nil..."
        case .lineReceiveMessageTypeNotMatch(let receiveMessageType):
            return "⚠️ ReceiveMessageType(\(receiveMessageType)) not match."
        case .replyTokenNotFound:
            return "⚠️ ReplyToken is not found."
        case .generateLineMessageFailed(let receiveMessageType):
            return "⚠️ GenerateLineMessage failed... receiveMessageType(\(receiveMessageType))"
        case .replyLineMessageFailed(let error):
            return "⚠️ Reply lineMessage failed... Error(\(error))"
        case .handleLineEventFailed(let reason):
            return "⚠️ Handle lineEvent failed because \(reason)..."
        }
    }
}
