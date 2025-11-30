//
//  VoiceSpeed.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Models/VoiceSpeed.swift
//
//  🎯 ファイルの目的:
//      話速を定義する。AVSpeechUtterance.rate にマッピング可能。
//
//  🔗 依存:
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - VoiceProfile.swift
//      - VoiceExtensions.swift（rate 変換）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public enum VoiceSpeed: String, CaseIterable, Codable {
    case slow
    case normal
    case fast
}
