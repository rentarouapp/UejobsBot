//
//  ResourceUtil.swift
//  UejobsBot
//
//  Created by 上條蓮太朗 on 2025/05/06.
//

import Vapor

struct ResourceUtil {
    // Jobsの名言（文字列配列）を返す
    static func loadJobsQuotes(from app: Application) throws -> [String] {
        let filePath = app.directory.workingDirectory + "Sources/UejobsBot/Resources/jobs-quotes.json"
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileURL)
        let quotes = try JSONDecoder().decode([String].self, from: data)
        return quotes
    }
    // Jobsの画像URL（文字列配列）を返す
    static func loadJobsImages(from app: Application) throws -> [String] {
        let filePath = app.directory.workingDirectory + "Sources/UejobsBot/Resources/jobs-images.json"
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileURL)
        let quotes = try JSONDecoder().decode([String].self, from: data)
        return quotes
    }
}
