//
//  VoiceManager.swift
//  CompanionVoiceSDK
//
//  📂 格納場所:
//      CompanionVoiceSDK/Managers/VoiceManager.swift
//
//  🎯 ファイルの目的:
//      アクティブなコンパニオンの VoiceProfile を管理。
//      - QuestMe 起動中は activeVoiceProfile を維持（CompanionManager の active と連動）
//      - 変更時は即時反映し、VoiceStorage に保存。
//
//  🔗 依存:
//      - VoiceProfile.swift
//      - VoiceStorage.swift
//      - VoiceRepository.swift
//      - Foundation
//
//  🔗 関連/連動ファイル:
//      - CompanionManager（activeCompanion と同期）
//      - CompanionOverlay（再生に利用）
//      - VoiceGenerator（再生成）
//
//  👤 作成者: 津村 淳一
//  📅 作成日: 2025年11月24日
//

import Foundation

public final class VoiceManager {
    public static let shared = VoiceManager()
    private init() {}

    private var activeVoiceProfile: VoiceProfile?

    /// 起動時に最後のアクティブ音声を復元
    public func bootstrapActiveVoice(for companionID: UUID) {
        if let saved = VoiceStorage.loadActive(companionID: companionID) {
            activeVoiceProfile = saved
        } else {
            activeVoiceProfile = nil
        }
    }

    public func getActiveVoice() -> VoiceProfile? {
        return activeVoiceProfile
    }

    public func setActiveVoice(_ profile: VoiceProfile) {
        activeVoiceProfile = profile
        VoiceStorage.saveActive(profile)
    }

    /// コンパニオン切替時に呼び出し（CompanionManager から）
    public func switchCompanion(to companionID: UUID) {
        activeVoiceProfile = VoiceStorage.loadActive(companionID: companionID)
    }
}
