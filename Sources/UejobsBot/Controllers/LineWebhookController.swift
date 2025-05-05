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
    
    func handle(req: Request) async throws -> HTTPStatus {
        do {
            // LINEのWebhookから送られたJSONをデコード
            let body = try req.content.decode(LineWebhookPayload.self)
            print("✅ Received LINE event: \(body).")
            for event in body.events {
                if event.type == "message", let message = event.message, message.type == "text", let text = message.text, let replyToken = event.replyToken {
                    try await reply(to: replyToken, with: text, client: req.client)
                }
            }
            return .ok
        } catch {
            print("⚠️ Received LINE event Error.")
            return .notFound
        }
    }
    
    private func reply(to token: String, with text: String, client: any Client) async throws {
        let url = URI(string: "https://api.line.me/v2/bot/message/reply")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Environment.get("LINE_CHANNEL_ACCESS_TOKEN") ?? "")",
            "Content-Type": "application/json"
        ]
        let body = LineReplyBody(
            replyToken: token,
            messages: [
                LineMessage(type: "text", text: text)
            ]
        )
        let _ = try await client.post(url, headers: headers, content: body)
    }
    
    func receive(_ req: Request) async throws -> HTTPStatus {
        // LINEのWebhookから送られたJSONをデコード
        do {
            let body = try req.content.decode(LineWebhookPayload.self)
            // ここでイベント内容に応じた処理を行う
            print("✅ Received LINE event: \(body).")
            return .ok
        } catch {
            print("⚠️ Received LINE event Error.")
            return .notFound
        }
    }
}
