//
//  AppStoreReviewManager.swift
//  wordgameart
//
//  Created by Ken on 2/6/22.
//

import StoreKit

/// Manages prompt for user to review the app in the app store
enum AppStoreReviewManager {
  
  static let minimumReviewWorthyActionCount = 15
  
  private static let currentActionCountKey = "AppStoreReviewCurrentActionCountKey"
  private static let lastReviewAppVersionKey = "AppStoreLastReviewAppVersionKey"
  
  /// Determines if it is appropropriate to present user with request to review app,
  /// requests if necessary
  static func requestReviewIfAppropriate() {
    let defaults = UserDefaults.standard
    let bundle = Bundle.main
    
    var actionCount = defaults.integer(forKey: currentActionCountKey)
    actionCount += 1
    defaults.set(actionCount, forKey: currentActionCountKey)
    
    // Ensure user has performed the action count a sufficient number of times
    guard actionCount >= minimumReviewWorthyActionCount else { return }
    
    let bundleVersionKey = kCFBundleVersionKey as String
    let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
    let lastVersion = defaults.string(forKey: lastReviewAppVersionKey)
    
    // Ensure user has not already seen a prompt for this version.  Apple will only
    // show prompt for each version once.
    guard lastVersion == nil || lastVersion != currentVersion else { return }
    
    // Request review and reset counters
    if let scene = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive })
        as? UIWindowScene {
      SKStoreReviewController.requestReview(in: scene)
    }
    defaults.set(0, forKey: currentActionCountKey)
    defaults.set(currentVersion, forKey: lastReviewAppVersionKey)
  }
  
}

