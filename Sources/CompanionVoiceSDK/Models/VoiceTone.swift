//
//  VoiceTone.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Models/VoiceTone.swift
//
//  🎯 ファイルの目的:
//      声のトーンを定義する。
//      - コミュニケーション文脈に応じた印象カテゴリ
//      - 声楽的な音域分類（女声/男声）
//      - AVSpeechUtterance.pitchMultiplier 等にマッピング可能
//
//  🔗 依存:
//      - Foundation
//      - VoiceProfile.swift（CompanionsSDK側で利用）
//      - VoiceExtensions.swift（ピッチ変換）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月30日
//

import Foundation

public enum VoiceTone: String, CaseIterable, Codable {
    // 基本的な高さ分類
    case high        // 明るい・元気・親しみやすい
    case low         // 落ち着き・誠実・信頼感

    // コミュニケーション文脈
    case authoritative // 権威的・専門性・信頼
    case friendly      // 温かく親しみやすい
    case formal        // 丁寧・構造化・ビジネス向け
    case empathetic    // 思いやり・安心感
    case enthusiastic  // 活気・ポジティブ

    // 声楽的分類（女声）
    case soprano       // 高音域・華やか
    case mezzoSoprano  // 中音域・包容力
    case alto          // 低音域・安定感

    // 声楽的分類（男声）
    case tenor         // 高音域・張りのある声
    case baritone      // 中音域・力強さと柔らかさ
    case bass          // 低音域・重厚感

    // デフォルト
    case neutral       // 標準的・ニュートラル
}
