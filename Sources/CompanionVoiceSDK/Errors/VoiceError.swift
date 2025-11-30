//
//  VoiceError.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Errors/VoiceError.swift
//
//  🎯 ファイルの目的:
//      音声生成・保存・推定で発生するエラーの定義。
//      - UI/ログに安全に伝えられるメッセージを提供。
//
//  🔗 依存:
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - VoiceGenerator.swift
//      - VoiceStorage.swift
//      - VoiceInference.swift
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public enum VoiceError: Error {
    case inferenceFailed
    case generationFailed
    case storageFailed
    case activeProfileMissing

    public var message: String {
        switch self {
        case .inferenceFailed:     return "初期音声の推定に失敗しました。"
        case .generationFailed:    return "音声ファイルの生成に失敗しました。"
        case .storageFailed:       return "音声設定の保存に失敗しました。"
        case .activeProfileMissing:return "アクティブな音声プロファイルが見つかりません。"
        }
    }
}
