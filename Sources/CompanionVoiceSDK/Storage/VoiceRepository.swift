//
//  VoiceRepository.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Storage/VoiceRepository.swift
//
//  🎯 ファイルの目的:
//      VoiceProfile の取得・更新を統一的に扱うリポジトリ。
//      - Active の保存/復元をラップ。
//      - 将来的なデータソースの差し替えポイント。
//
//  🔗 依存:
//      - VoiceProfile.swift
//      - VoiceStorage.swift
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - VoiceManager.swift
//      - VoiceGenerator.swift
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public final class VoiceRepository {
    public init() {}

    public func saveActive(_ profile: VoiceProfile) {
        VoiceStorage.saveActive(profile)
    }

    public func loadActive(companionID: UUID) -> VoiceProfile? {
        VoiceStorage.loadActive(companionID: companionID)
    }
}
