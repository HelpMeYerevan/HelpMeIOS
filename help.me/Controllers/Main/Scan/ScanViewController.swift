//
//  ScanViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit
import AVFoundation
import Photos

public final class ScanViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var captureAddCurrentJobLabel: UILabel!
    @IBOutlet private weak var previewView: PreviewView!
    @IBOutlet private weak var photoLibraryButton: UIButton!
    @IBOutlet private weak var cameraSwapButton: UIButton!
    @IBOutlet private weak var captureButton: UIButton!

    // MARK: Properties
    private var isFront = false
    private var session = AVCaptureSession()
    private var isSessionRunning = false
    private var cameraStatus: SessionSetupResult = .success
    private let sessionQueue = DispatchQueue(label: "session queue")
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private let photoOutput = AVCapturePhotoOutput()
    private let imagePicker = UIImagePickerController()
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .front)
    private let videoDeviceDiscoverySessionBack = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInTripleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .back)
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    private var type: ScanType = .work

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureCameraIfAvailable()
        configurePhotoLibraryIfAvailable()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        DispatchQueue.global(qos: .userInitiated).async {
            self.startCameraIfAvailable()
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async {
            if self.cameraStatus == .success {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
            }
        }
    }

    // MARK: Methods
    private func setupTabBar() {
        tabBarController?.setTabBarHidden(false)
    }
    
    private func configureCameraIfAvailable() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                self.configureSession()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.cameraStatus = .notAuthorized
                } else {
                    DispatchQueue.main.async {
                        self.configureSession()
                    }
                }
            })
        default:
            cameraStatus = .notAuthorized
        }
    }
    
    private func configurePhotoLibraryIfAvailable() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }

    private func configureSession() {
        previewView.session = session
        if cameraStatus != .success {
            return
        }
        session.beginConfiguration()
        session.sessionPreset = .photo
        if self.session.canSetSessionPreset(.photo) {
            self.session.sessionPreset = .photo
        }
        do {
            let defaultVideoDevice = AVCaptureDevice.default(for: .video)
            guard let videoDevice = defaultVideoDevice else {
                cameraStatus = .configurationFailed
                session.commitConfiguration()
                return
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                DispatchQueue.main.async {
                    self.previewView.videoPreviewLayer.connection?.videoOrientation = .portrait
                }
            } else {
                cameraStatus = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            cameraStatus = .configurationFailed
            session.commitConfiguration()
            return
        }
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
        } else {
            cameraStatus = .configurationFailed
            session.commitConfiguration()
            return
        }
        session.commitConfiguration()
    }

    private func startCameraIfAvailable() {
        sessionQueue.async {
            switch self.cameraStatus {
            case .success:
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                    DispatchQueue.main.async {
                        self.captureButton.isEnabled = true
                    }
            case .notAuthorized:
                DispatchQueue.main.async {
                    let changePrivacySetting = "help.me doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "help.me", message: message, preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            case .configurationFailed:
                DispatchQueue.main.async {
                    let message = NSLocalizedString("Unable to capture media", comment: "")
                    let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func startPhotoLibraryIfAvailable() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: present(self.imagePicker, animated: true)
        case .notDetermined: PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true)
                    }
                }
            })
        default: break
        }
    }
    
    public func setType(_ type: ScanType) {
        self.type = type
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        captureAddCurrentJobLabel.setLocalizedString(.scan_captureAddCurrentJob)
    }

    // MARK: Actions
    @IBAction private func captureButtonAction(_ sender: UIButton) {
        if cameraStatus != .success {
            startCameraIfAvailable()
            return
        }
        captureButton.isEnabled = false
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    @IBAction private func photoLibraryButtonAction(_ sender: UIButton) {
        sessionQueue.async {
            self.session.stopRunning()
            self.isSessionRunning = self.session.isRunning
        }
        startPhotoLibraryIfAvailable()
    }

    @IBAction private func cameraSwapButtonAction(_ sender: UIButton) {
        if cameraStatus != .success {
            startCameraIfAvailable()
            return
        }
        sessionQueue.async {
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            let preferredPosition: AVCaptureDevice.Position
            switch currentPosition {
            case .unspecified, .front: preferredPosition = .back
            case .back: preferredPosition = .front
            default: preferredPosition = .back
            }
            let devices = self.isFront ? self.videoDeviceDiscoverySession.devices : self.videoDeviceDiscoverySessionBack.devices
            var newVideoDevice: AVCaptureDevice? = nil
            if let device = devices.first(where: { $0.position == preferredPosition }) {
                newVideoDevice = device
            }
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    self.session.beginConfiguration()
                    self.session.removeInput(self.videoDeviceInput)
                    if self.session.canAddInput(videoDeviceInput) {
                        self.session.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.session.addInput(self.videoDeviceInput)
                    }
                    self.photoOutput.isDepthDataDeliveryEnabled = self.photoOutput.isDepthDataDeliverySupported
                    self.photoOutput.isPortraitEffectsMatteDeliveryEnabled = self.photoOutput.isPortraitEffectsMatteDeliverySupported
                    self.session.commitConfiguration()
                } catch {
                    print("Error occurred while creating video device input: \(error)")
                }
            }
        }
        isFront.toggle()
    }
}

// MARK: Navigations
extension ScanViewController {
    private func pushToAddWorkViewController(with image: UIImage) {
        guard let viewController = viewController(from: .main, withIdentifier: .addWorkViewController) as? AddWorkViewController else { return }
        viewController.setWorkImage(image)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToAddPhotoViewController(with image: UIImage) {
        guard let viewController = viewController(from: .main, withIdentifier: .addPhotoViewController) as? AddPhotoViewController else { return }
        viewController.setPhotoImage(image)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: AVCapturePhotoCaptureDelegate
extension ScanViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        sessionQueue.async {
            self.session.stopRunning()
            self.isSessionRunning = self.session.isRunning
        }
        if let _ = error {
            print("Unable to capture photo")
        } else if let dataImage = photo.fileDataRepresentation() {
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: videoDeviceInput.device.position == .back ? .right : .leftMirrored).orientationFixed()
            switch type {
                case .work: pushToAddWorkViewController(with: image)
                case .photo: pushToAddPhotoViewController(with: image)
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ScanViewController {
    public override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                switch self.type {
                    case .work: self.pushToAddWorkViewController(with: image)
                    case .photo: self.pushToAddPhotoViewController(with: image)
                }
            }
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        session.startRunning()
        dismiss(animated: true, completion: nil)
    }
}
