//
//  ScanPaymentCardViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import UIKit
import PayCardsRecognizer

public final class ScanPaymentCardViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var scannerView: UIView!
    
    // MARK: Properties
    private var payCardsRecognizer: PayCardsRecognizer!
    public var paymentCardDidScanned: ((PayCardsRecognizerResult) -> Void)?

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPaymentCardScanner()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCapturing()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCapturing()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
    }
    
    private func setupPaymentCardScanner() {
        payCardsRecognizer = PayCardsRecognizer(delegate: self, resultMode: .async, container: scannerView, frameColor: .hex_6BC24D)
    }
    
    private func startCapturing() {
        payCardsRecognizer.startCamera()
    }
    
    private func stopCapturing() {
        payCardsRecognizer.stopCamera()
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.scanCreditCard_scanCreditDebitCard)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: CreditCardScannerViewControllerDelegate
extension ScanPaymentCardViewController: PayCardsRecognizerPlatformDelegate {
    public func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        if result.isCompleted {
            paymentCardDidScanned?(result)
            popViewController()
        }
    }
}
