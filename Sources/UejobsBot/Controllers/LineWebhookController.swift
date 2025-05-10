//
//  LineWebhookController.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

struct LineWebhookController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.post("callback", use: handle)
    }
}

private extension LineWebhookController {
    private func handle(req: Request) async throws -> HTTPStatus {
        do {
            print("✅ Received LINE event.")
            // ラインメッセージ作る
            let lineMessage = try LineMessageGenerator.lineMessage(req: req)
            // リプライする
            return try await reply(lineMessage: lineMessage, req: req)
        } catch {
            throw error
        }
    }
    
    private func reply(lineMessage: LineMessage, req: Request) async throws -> HTTPStatus {
        let body = try req.content.decode(LineWebhookPayload.self)
        guard let event = body.events.first else {
            throw LineWebhookError.payloadEventIsEmpty
        }
        guard let replyToken = event.replyToken else {
            throw LineWebhookError.replyTokenNotFound
        }
        let url = URI(string: "https://api.line.me/v2/bot/message/reply")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Environment.get("LINE_CHANNEL_ACCESS_TOKEN") ?? "")",
            "Content-Type": "application/json"
        ]
        let lineReplyBody = LineReplyBody(
            replyToken: replyToken,
            messages: [lineMessage]
        )
        print("💡 Header: \(headers)")
        print("🤖 Body: \(lineReplyBody)")
        do {
            let response = try await req.client.post(url, headers: headers, content: lineReplyBody)
            return response.status
        } catch {
            throw error
        }
    }
}

enum ReceiveMessageType: String {
    case text = "text"
    case location = "location"
}

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
