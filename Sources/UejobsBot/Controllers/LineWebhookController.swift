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
    
    private func handle(req: Request) async throws -> HTTPStatus {
        do {
            // LINEのWebhookから送られたJSONをデコード
            let body = try req.content.decode(LineWebhookPayload.self)
            print("✅ Received LINE event: \(body).")
            guard let event = body.events.first else {
                print("⚠️ Event is Empty...")
                return .notFound
            }
            guard let message = event.message else {
                print("⚠️ Received, But ['message'] is nil...")
                return .notFound
            }
            switch message.type {
            case "text":
                // テキストメッセージが送られた
                return try await handleText(event: event, req: req)
            case "location":
                // 場所情報が送られた
                return try await handleLocation(event: event, req: req)
            default:
                print("⚠️ Received LINE event Error.")
                return .notFound
            }
        } catch {
            print("⚠️ Received, But Not Expected Message Type...")
            return .notFound
        }
    }
    
    private func reply(lineMessage: LineMessage, replyToken: String, client: any Client) async throws {
        let url = URI(string: "https://api.line.me/v2/bot/message/reply")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Environment.get("LINE_CHANNEL_ACCESS_TOKEN") ?? "")",
            "Content-Type": "application/json"
        ]
        let body = LineReplyBody(
            replyToken: replyToken,
            messages: [lineMessage]
        )
        print("💡 Header: \(headers)")
        print("🤖 Body: \(body)")
        do {
            let _ = try await client.post(url, headers: headers, content: body)
            print("✅ Post Success!")
        } catch {
            print("⚠️ Post Failed...")
            print("⚠️ Error: \(error)")
        }
    }
}

extension LineWebhookController {
    // テキストメッセージのハンドリング
    private func handleText(event: LineEvent, req: Request) async throws -> HTTPStatus {
        guard let replyToken = event.replyToken else {
            print("⚠️ Received, But Not ReplyToken...")
            return .notFound
        }
        guard let lineMessage = TextUtil.lineMessageFromTextTypeEvent(event: event) else {
            print("⚠️ Received, But Not Text Event...")
            return .notFound
        }
        print("✅ Generate LineMessage.")
        do {
            try await reply(lineMessage: lineMessage, replyToken: replyToken, client: req.client)
            print("✅ Text Reply Success!")
            return .ok
        } catch {
            print("⚠️ Text Reply Failed...")
            print("⚠️ Text Reply Error: \(error)")
            return .notFound
        }
    }
    
    // 緯度経度のハンドリング
    private func handleLocation(event: LineEvent, req: Request) async throws -> HTTPStatus {
        guard let replyToken = event.replyToken else {
            print("⚠️ Received, But Not ReplyToken...")
            return .notFound
        }
        guard let lineMessage = LocationUtil.lineMessageFromLocationTypeEvent(event: event) else {
            print("⚠️ Received, But Not Location Event...")
            return .notFound
        }
        print("✅ Generate LineMessage.")
        do {
            try await reply(lineMessage: lineMessage, replyToken: replyToken, client: req.client)
            print("✅ Location Reply Success!")
            return .ok
        } catch {
            print("⚠️ Location Reply Failed...")
            print("⚠️ Location Reply Error: \(error)")
            return .notFound
        }
    }
}
