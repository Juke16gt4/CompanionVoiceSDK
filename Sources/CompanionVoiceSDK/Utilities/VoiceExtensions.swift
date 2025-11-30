//
//  VoiceExtensions.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Utilities/VoiceExtensions.swift
//
//  🎯 ファイルの目的:
//      音声関連の共通ユーティリティ。
//      - ファイル名生成（style_tone_speed.m4a）
//      - コンパニオンのアセットフォルダ存在保証（画像と連動）
//      - 話速/トーンの TTS 変換マッピング
//
//  🔗 依存:
//      - VoiceProfile.swift
//      - VoiceSpeed.swift
//      - VoiceTone.swift
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - VoiceGenerator.swift
//      - VoiceInference.swift
//      - CompanionImageProcessor（画像保存パスと連動）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public enum VoiceExtensions {
    /// ファイル名: style_tone_speed.m4a
    public static func filename(for profile: VoiceProfile) -> String {
        "\(profile.style.rawValue)_\(profile.tone.rawValue)_\(profile.speed.rawValue).m4a"
    }

    /// コンパニオンのアセットフォルダ（画像と同居）を保証
    /// 例: Documents/Companions/<companionID>/
    public static func ensureCompanionAssetFolder(_ baseFolder: URL) -> URL {
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: baseFolder.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(at: baseFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return baseFolder
    }

    /// 保存先の推奨ルート（Documents/Companions/<id>）
    public static func defaultAssetFolder(for companionID: UUID) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = docs.appendingPathComponent("Companions").appendingPathComponent(companionID.uuidString)
        return ensureCompanionAssetFolder(folder)
    }

    /// 話速を AVSpeechUtterance.rate に変換
    public static func mapSpeedToRate(_ speed: VoiceSpeed) -> Float {
        switch speed {
        case .slow:   return 0.40
        case .normal: return 0.50
        case .fast:   return 0.65
        }
    }

    /// トーンを AVSpeechUtterance.pitchMultiplier に変換
    public static func mapToneToPitch(_ tone: VoiceTone) -> Float {
        switch tone {
        case .bright:  return 1.20
        case .deep:    return 0.85
        case .husky:   return 0.95
        case .soft:    return 1.05
        case .neutral: return 1.00
        }
    }
}
