//
//  LineWebhookController.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

struct LineWebhookController {
    func receive(_ req: Request) async throws -> HTTPStatus {
        // LINEのWebhookから送られたJSONをデコード
        do {
            let body = try req.content.decode(LineWebhookPayload.self)
            // ここでイベント内容に応じた処理を行う
            print("Received LINE event: \(body)")
            return .ok
        } catch {
            print("Received LINE event Error.")
            return .notFound
        }
    }
}
