//
//  VoiceInference.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Services/VoiceInference.swift
//
//  🎯 ファイルの目的:
//      顔の骨格特徴から VoiceProfile（style/tone/speed）を推定。
//      - Companion の画像解析結果（特徴量）に応じて初期音声を自動設定。
//      - 生成後は VoiceGenerator で音声ファイルを作成・保存。
//
//  🔗 依存:
//      - VoiceStyle.swift
//      - VoiceTone.swift
//      - VoiceSpeed.swift
//      - VoiceProfile.swift
//      - VoiceExtensions.swift（アセットフォルダ生成）
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - CompanionFactory（初期生成時に利用）
//      - CompanionImageProcessor（顔特徴抽出）
//      - VoiceGenerator（ファイル生成）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

/// 顔骨格の簡易特徴量
public struct FacialFeatures: Codable {
    public let jawSharpness: Float   // 顎ラインのシャープさ（0.0〜1.0）
    public let eyeSize: Float        // 目の大きさ（0.0〜1.0）
    public let softness: Float       // 全体の柔らかさ（0.0〜1.0）
    public let energy: Float         // 活力印象（0.0〜1.0）
}

public final class VoiceInference {
    public init() {}

    /// 顔特徴から初期 VoiceProfile を推定
    public func inferProfile(
        for companionID: UUID,
        features: FacialFeatures,
        assetFolderURL: URL
    ) -> VoiceProfile {
        let style: VoiceStyle = {
            if features.energy > 0.7 || features.jawSharpness > 0.7 { return .energetic }
            if features.softness > 0.7 { return .gentle }
            return .calm
        }()

        let tone: VoiceTone = {
            if features.eyeSize > 0.6 { return .bright }
            if features.jawSharpness > 0.7 { return .deep }
            return .neutral
        }()

        let speed: VoiceSpeed = {
            if features.energy > 0.8 { return .fast }
            if features.softness > 0.7 { return .slow }
            return .normal
        }()

        return VoiceProfile(
            companionID: companionID,
            style: style,
            tone: tone,
            speed: speed,
            assetFolderURL: VoiceExtensions.ensureCompanionAssetFolder(assetFolderURL)
        )
    }
}
