//
//  ViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit
import AuthenticationServices
import FBSDKLoginKit
import Photos
import LocalAuthentication
import GoogleMaps
import CoreLocation

public class BaseViewController: UIViewController {
    
    // MARK: Properties
    private var keyboardManager: KeyboardManager!
    //    private var facebookUserProfile: FacebookUserProfile?
    public var temporaryCode: String?
    private var email: String?
    public var isSmallDevice: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            return UIScreen.main.nativeBounds.height <= 1136
        }
        return false
    }
    public var isDeviceHasNotch: Bool {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
    }
    public override var tabBarController: TabBarController? {
        return UIApplication.sceneDelegateWindow?.rootViewController as? TabBarController
    }
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    private var context = LAContext()
    public var biometricType: BiometricType {
        context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        switch context.biometryType {
            case .touchID: return .touchID
            case .faceID: return .faceID
            default: return .none
        }
    }
    public var profile: Profile? {
        return ConfigDataProvider.currentProfile
    }
    private(set) var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.18638286444796, longitude: 44.51516643068837, zoom: 3.0)
        let mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        return mapView
    }()
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    private(set) var currentLocation: CLLocation? {
        didSet {
            guard let currentLocation = currentLocation else { return }
            mapView.animate(toLocation: currentLocation.coordinate)
        }
    }
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        if profile == nil {
            ConfigDataProvider.currentProfile = ConfigDataProvider.lastSignedInProfile
        }
        keyboardManager = KeyboardManager(delegate: self, disableAnimation: false)
        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMapView()
        setupNavigationBar()
        setupLocalization()
    }
    
    // MARK: Methods
    public func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    public func setupView() { }
    public func setupLocalization() { }
    private func setupMapView() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    //    public func selectTabBarItem(_ selectedItemType: TabBarItemType) {
    //        (tabBarController as? TabBarController)?.selectTabBarItem(for: selectedItemType)
    //    }
    //
    //    public func tabBarItemDidTapped(_ action: @escaping () -> Void) {
    //        (tabBarController as? TabBarController)?.tabBarItemDidTapped = action
    //    }
    //
    //    public func setBadge(_ value: Int, forTabBarItem type: TabBarItemType) {
    //        (tabBarController as? TabBarController)?.setBadge(with: value, forTabBarItem: type)
    //    }
    
    public func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(with title: String, and message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(with error: Error) {
        var message = ""
        if let error = error as? NetworkError {
            if error == .unauthorized {
                guard let viewController = viewController(from: .authorization, withIdentifier: .signInViewController) as? SignInViewController else { return }
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .custom
                navigationController.navigationBar.isHidden = true
                UIApplication.sceneDelegateWindow?.rootViewController = navigationController
                UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
            }
            message = error.message
        } else {
            message = error.localizedDescription
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(with error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    public func showDevelopmentAlert() {
        let alert = UIAlertController(title: "Under Construction", message: "Please, be patient. Developers are working on that feature. It'll be available soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    //    public func showAlertView(with type: AlertViewType, and action: @escaping () -> Void) {
    //        appKeyWindow?.rootViewController?.view.subviews.forEach({ subview in
    //            if subview.tag == Constants.alertViewTag {
    //                subview.removeFromSuperview()
    //            }
    //        })
    //        let alertView = AlertView(with: type)
    //        alertView.tag = Constants.alertViewTag
    //        alertView.okButtonDidTapped = {
    //            action()
    //            alertView.removeFromSuperview()
    //        }
    //        appKeyWindow?.rootViewController?.view.addSubview(alertView)
    //    }
    //
    public func showActivityIndicator() {
        view.endEditing(true)
        UIApplication.sceneDelegateWindow?.rootViewController?.view.subviews.forEach({ subview in
            if subview.tag == Constants.activityIndicatorViewTag {
                subview.removeFromSuperview()
            }
        })
        let activityIndicatorView = UIView(frame: UIScreen.main.bounds)
        activityIndicatorView.backgroundColor = UIColor.transparentViewBackgroundColor
        activityIndicatorView.tag = Constants.activityIndicatorViewTag
        activityIndicatorView.layer.zPosition = 99999999999
        UIApplication.sceneDelegateWindow?.rootViewController?.view.addSubview(activityIndicatorView)
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        activityIndicatorView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: activityIndicatorView.leadingAnchor, constant: 38),
            stackView.trailingAnchor.constraint(equalTo: activityIndicatorView.trailingAnchor, constant: -38)
        ])
        let informationLabel = UILabel()
        informationLabel.text = "Please wait"
        informationLabel.textAlignment = .center
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .systemBackground
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 17)
        stackView.addArrangedSubview(informationLabel)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        activityIndicator.color = .systemBackground
        stackView.addArrangedSubview(activityIndicator)
    }
    
    public func hideActivityIndicator() {
        UIApplication.sceneDelegateWindow?.rootViewController?.view.subviews.forEach { subview in
            if subview.tag == Constants.activityIndicatorViewTag {
                subview.removeFromSuperview()
            }
        }
    }
    
    public func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    public func dismissViewController() {
        dismiss(animated: true)
    }
    
    public func open(_ url: URL?) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    public func resetPushNotificationsCount() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    public func showActionSheetForPhotoLibraryOrCamera() {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.checkPermissionForPhotoLibrary()
        })
        alertSheet.addAction(photoLibraryAction)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.checkPermissionForCamera()
        })
        alertSheet.addAction(cameraAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }
    
    private func checkPermissionForPhotoLibrary() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        switch photoAuthorizationStatus {
            case .authorized: present(imagePicker, animated: true, completion: nil)
            case .notDetermined: PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
            })
            default: break
        }
    }
    
    private func checkPermissionForCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        switch cameraAuthorizationStatus {
            case .authorized: present(imagePicker, animated: true, completion: nil)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { isGranted in
                    if isGranted {
                        DispatchQueue.main.async {
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                }
            default: break
        }
    }
    
    public func canEvaluatePolicyForDeviceOwnerAuthentication(completion: @escaping (Bool) -> Void) {
        context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            completion(true)
        } else {
            completion(false)
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func evaluatePolicyForDeviceOwnerAuthentication(completion: @escaping (Bool) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Sign In to help.me" ) { isSuccess, error in
            completion(isSuccess)
            if let error = error, !isSuccess {
                print(error.localizedDescription)
            }
        }
    }
        
    // MARK: Continue With
    //    public func showFacebookSignIn() {
    //        showActivityIndicator()
    //        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
    //            guard let self = self else { return }
    //            if let result = result, result.isCancelled {
    //                self.hideActivityIndicator()
    //                return
    //            }
    //            self.getFacebookUserProfile()
    //        }
    //    }
    
    public func showAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //    private func getFacebookUserProfile() {
    //        let connection = GraphRequestConnection()
    //        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields" : "id, first_name, last_name, email, picture.type(large)"], httpMethod: .get)) { [weak self] (connection, response, error) in
    //            guard let self = self else { return }
    //            if let error = error {
    //                self.hideActivityIndicator()
    //                self.showAlert(with: error)
    //            } else {
    //                guard let userInfo = response as? [String : Any] else { return }
    //                do {
    //                    let data = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
    //                    let decoder = JSONDecoder()
    //                    self.facebookUserProfile = try decoder.decode(FacebookUserProfile.self, from: data)
    //                    self.getFacebookUserProfileImage()
    //                } catch let error {
    //                    self.hideActivityIndicator()
    //                    self.showAlert(with: error)
    //                }
    //            }
    //        }
    //        connection.start()
    //    }
    
    //    private func getFacebookUserProfileImage() {
    //        if let pictureUrl = self.facebookUserProfile?.picture?.data?.url {
    //            NetworkManager.shared.getImage(with: pictureUrl) { [weak self] profileImage in
    //                guard let self = self else { return }
    //                self.hideActivityIndicator()
    //                self.facebookUserProfile?.profileImage = profileImage
    //                guard let facebookUserProfile = self.facebookUserProfile else { return }
    //                self.showActivityIndicator()
    //                ConfigDataProvider.userProfile = nil
    //                NetworkManager.shared.continueWith(with: .facebook, providerUserId: facebookUserProfile.id, avatar: facebookUserProfile.profileImage ?? .imageEmptyProfilePhoto, email: facebookUserProfile.email, firstName: facebookUserProfile.firstName, lastName: facebookUserProfile.lastName, birthday: facebookUserProfile.birthday ?? ConfigDataProvider.defaultUserProfileBirthday, gender: facebookUserProfile.gender ?? .other, code: self.temporaryCode) { [weak self] response in
    //                    guard let self = self else { return }
    //                    self.hideActivityIndicator()
    //                    if response.isSuccess {
    //                        ConfigDataProvider.accessToken = response.accessToken
    //                        if let accessToken = ConfigDataProvider.accessToken {
    //                            print("***\nACCESS TOKEN\nBearer \(accessToken)\n***\n")
    //                        }
    //                        if response.code == nil {
    //                            self.show(viewController: .tabBarController)
    //                        } else {
    //                            if self.temporaryCode != nil {
    //                                self.show(viewController: .tabBarController)
    //                            } else {
    //                                self.email = facebookUserProfile.email
    //                                self.show(viewController: .inviteYourPartnerViewController, with: response.code)
    //                            }
    //                        }
    //                    } else {
    //                        guard let message = response.message else { return }
    //                        self.showAlert(with: "Error", and: response.message ?? message)
    //                    }
    //                } failure: { [weak self] error in
    //                    guard let self = self else { return }
    //                    self.hideActivityIndicator()
    //                    self.showAlert(with: error)
    //                }
    //            } failure: { [weak self] error in
    //                guard let self = self else { return }
    //                self.hideActivityIndicator()
    //                self.showAlert(with: error)
    //            }
    //        }
    //    }
    //
    //    private func show(viewController: ViewControllerIdentifier, with code: String? = nil) {
    //        switch viewController {
    //        case .tabBarController:
    //            guard let viewController = self.viewController(from: .main, withIdentifier: .tabBarController) as? TabBarController else { return }
    //            appKeyWindow?.rootViewController = viewController
    //            appKeyWindow?.makeKeyAndVisible()
    //        case .inviteYourPartnerViewController:
    //            guard let viewController = self.viewController(from: .authorization, withIdentifier: .inviteYourPartnerViewController) as? InviteYourPartnerViewController else { return }
    //            viewController.code = code
    //            if let email = email, let code = code {
    //                if ConfigDataProvider.code == nil {
    //                    ConfigDataProvider.code = [email : code]
    //                } else {
    //                    ConfigDataProvider.code?[email] = code
    //                }
    //            }
    //            self.navigationController?.pushViewController(viewController, animated: true)
    //        default: break
    //        }
    //    }
}

// MARK: KeyboardEventsDelegate
extension BaseViewController: KeyboardEventsDelegate {
    @objc public func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) { }
}

// MARK: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
extension BaseViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        //            showActivityIndicator()
        //            ConfigDataProvider.userProfile = nil
        //            NetworkManager.shared.continueWith(with: .apple, providerUserId: appleIdCredential.user, avatar: .imageEmptyProfilePhoto, email: appleIdCredential.email, firstName: appleIdCredential.fullName?.givenName, lastName: appleIdCredential.fullName?.familyName, birthday: ConfigDataProvider.defaultUserProfileBirthday, gender: .other, code: self.temporaryCode) { [weak self] response in
        //                guard let self = self else { return }
        //                self.hideActivityIndicator()
        //                if response.isSuccess {
        //                    ConfigDataProvider.accessToken = response.accessToken
        //                    if let accessToken = ConfigDataProvider.accessToken {
        //                        print("***\nACCESS TOKEN\nBearer \(accessToken)\n***\n")
        //                    }
        //                    if response.code == nil {
        //                        self.show(viewController: .tabBarController)
        //                    } else {
        //                        if self.temporaryCode != nil {
        //                            self.show(viewController: .tabBarController)
        //                        } else {
        //                            self.email = appleIdCredential.email
        //                            self.show(viewController: .inviteYourPartnerViewController, with: response.code)
        //                        }
        //                    }
        //                } else {
        //                    guard let message = response.message else { return }
        //                    self.showAlert(with: "Error", and: response.message ?? message)
        //                }
        //            } failure: { [weak self] error in
        //                guard let self = self else { return }
        //                self.hideActivityIndicator()
        //                self.showAlert(with: error)
        //            }
        //        } else {
        //            print("Failed to get access token")
        //            showAlert(with: NetworkError.somethingWentWrong)
        //            return
        //        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed to continue with Apple: \(error.localizedDescription)")
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

// MARK: SignUpViewController, UINavigationControllerDelegate
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { }
}

// MARK: UIGestureRecognizerDelegate
extension BaseViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: CLLocationManagerDelegate
extension BaseViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        currentLocation = location
        locationManager.stopUpdatingLocation()
    }
}
