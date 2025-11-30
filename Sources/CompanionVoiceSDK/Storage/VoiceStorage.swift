//
//  VoiceStorage.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Storage/VoiceStorage.swift
//
//  🎯 ファイルの目的:
//      VoiceProfile の保存・復元を担当。
//      - アクティブ音声はコンパニオンID単位で保存。
//      - 将来 CoreData/Cloud へ拡張可能な抽象化ポイント。
//
//  🔗 依存:
//      - VoiceProfile.swift
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - VoiceManager.swift（アクティブ管理）
//      - VoiceRepository.swift（取得ラッパ）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public final class VoiceStorage {
    private static func activeKey(for companionID: UUID) -> String {
        "ActiveVoiceProfile_\(companionID.uuidString)"
    }

    public static func saveActive(_ profile: VoiceProfile) {
        let key = activeKey(for: profile.companionID)
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    public static func loadActive(companionID: UUID) -> VoiceProfile? {
        let key = activeKey(for: companionID)
        guard let data = UserDefaults.standard.data(forKey: key),
              let profile = try? JSONDecoder().decode(VoiceProfile.self, from: data) else {
            return nil
        }
        return profile
    }
}
