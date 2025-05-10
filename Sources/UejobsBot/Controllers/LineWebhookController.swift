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
