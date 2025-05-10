//
//  TextUtil.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

struct TextUtil {
    // テキストメッセージをもらってLineMessageを返す
    static func lineMessage(from event: LineEvent) throws -> LineMessage {
        guard let message = event.message,
              let text = message.text else {
            throw LineWebhookError.handleLineEventFailed("[message], [text] cannot be handled")
        }
        return LineMessage(type: "text", text: text) // 仮でオウム返ししておく
    }
}
