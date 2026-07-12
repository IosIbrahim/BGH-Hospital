//
//  AIBotOnboardingViewController.swift
//  CareMate
//
//  Entry / onboarding screen for the AI Bot ("VoiceDoc Assistance") feature.
//  Opened from the AI bot icon in the home header.
//

import UIKit

final class AIBotOnboardingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = AIBotStrings.assistantTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Home hides the navigation bar; show it here so the back button appears.
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = AIBotStrings.assistantTitle
    }
}
