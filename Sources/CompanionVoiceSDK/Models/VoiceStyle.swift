//
//  VoiceStyle.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Models/VoiceStyle.swift
//
//  🎯 ファイルの目的:
//      声質（スタイル）を定義する。コンパニオンの人格印象に対応。
//
//  🔗 依存:
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - VoiceTone.swift
//      - VoiceSpeed.swift
//      - VoiceProfile.swift
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public enum VoiceStyle: String, CaseIterable, Codable {
    case calm
    case energetic
    case gentle
    case lively
    case sexy
    case mentor
    case friendly
    case coach
}
