//
//  TextUtil.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/05.
//

import Vapor

enum TextUtil {
    // テキストメッセージをもらってLineMessageを返す
    static func lineMessageFromTextTypeEvent(event: LineEvent) -> LineMessage? {
        guard let message = event.message,
              let text = message.text else {
            print("⚠️ generateLineMessageFromReplyText Failed.")
            return nil
        }
        return LineMessage(type: "text", text: text) // 仮でオウム返ししておく
    }
}
