//
//  NetworkManager.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

public final class NetworkManager {
    
    // MARK: Properties
    public static let shared = NetworkManager()
    private let serviceProvider = ServiceProvider<RequestProvider>()
    
    // MARK: Initialization
    private init() { }
    
    // MARK: Methods
    // MARK: Prepare Sign Up
    public func prepareSignUp(success: @escaping (PrepareSignUp) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .prepareSignUp, decodeType: PrepareSignUp.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Sign Up
    public func signUp(name: String, email: String, password: String, phoneNumber: String, isAlsoWorker: Bool, accountType: AccountType?, activityType: Int?, categories: [Int]?, documents: String?, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .signUp(name: name, email: email, password: password, phoneNumber: phoneNumber, isAlsoWorker: isAlsoWorker, accountType: accountType, activityType: activityType, categories: categories, documents: documents), decodeType: Response.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Sign In
    public func signIn(with email: String, password: String, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .signIn(email: email, password: password), decodeType: Response.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Password Recovery
    public func passwordRecovery(with email: String, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .passwordRecovery(email: email), decodeType: Response.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Virification Code
    public func verifyCode(with profileID: Int, code: Int, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .verifyCode(profileID: profileID, code: code), decodeType: Response.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Resend Virification Code
    public func resendVerificationCode(success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .resendVerificationCode, decodeType: Response.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Stories
    public func getStories(for page: Int, success: @escaping (Stories) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getTopStories(page: page), decodeType: Stories.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Works
    public func getWorks(with categoryID: Int? = nil, page: Int, success: @escaping (Works) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getTopWorks(categoryID: categoryID, page: page), decodeType: Works.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Users
    public func getUsers(with categoryID: Int? = nil, success: @escaping (Users) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getTopUsers(categoryID: categoryID), decodeType: Users.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Categories
    public func getCategories(for page: Int, success: @escaping (Categories) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getTopCategories(page: page), decodeType: Categories.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
//    // MARK: Delete User Profile
//    public func deleteUserProfile(success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .deleteUserProfile, decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
    
    // MARK: Sign Out
    public func signOut(success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .signOut, decodeType: Response.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
//    // MARK: Reset Password
//    public func resetPassword(with currentPassword: String, newPassword: String, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .resetPassword(currentPassword: currentPassword, newPassword: newPassword), decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    //MARK: Check User Connection
//    public func checkUserConnection(success: @escaping (Bool) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .checkUserConnection, decodeType: Bool.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Get Scores
//    public func getScores(success: @escaping (Scores) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .getAnalytics, decodeType: Scores.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Get Category
//    public func getCategory(with id: Int, success: @escaping (Category) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .getCategory(id: id), decodeType: Category.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Get Categories
//    public func getCategories(with id: Int? = nil, success: @escaping ([Category]) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .getCategories(parentId: id), decodeType: [Category].self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Send Wish
//    public func sendWish(with title: String, description: String, image: UIImage?, reminder: ReminderType?, categoryId: Int, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .sendWish(title: title, description: description, image: image, reminder: reminder, categoryId: categoryId), decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Get Wish
//    public func getWish(with id: Int, success: @escaping (Wish) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .getWish(id: id), decodeType: Wish.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Get User Notifications
//    public func getUserNotifications(success: @escaping (Notifications) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .getUserNotifications, decodeType: Notifications.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Get User Evaluations
//    public func getUserEvaluations(success: @escaping (Evaluations) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .getUserEvaluations, decodeType: Evaluations.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Finish Evaluation
//    public func finishEvaluation(with wishId: Int, rate: Int, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .finishEvaluation(wishId: wishId, rate: rate), decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
    // MARK: Get Coordinates
    public func getCoordinates(with categoryID: Int? = nil, success: @escaping ([WorkCoordinate]) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getCoordinates(categoryID: categoryID), decodeType: [WorkCoordinate].self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Current Coordinate
    public func getCurrentCoordinate(with workID: Int, success: @escaping (CurrentWork) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getCurrentCoordinate(workID: workID), decodeType: CurrentWork.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Profile
    public func getProfile(success: @escaping (Profile) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getProfile, decodeType: Profile.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Update Profile
    public func updateProfile(with avatar: String? = nil, email: String? = nil, phoneNumber: String? = nil, isAlsoWorker: Bool? = nil, accountType: AccountType? = nil, activityType: Int? = nil, categories: [Int]? = nil, documents: String? = nil, success: @escaping (Profile) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .updateProfile(avatar: avatar, email: email, phoneNumber: phoneNumber, isAlsoWorker: isAlsoWorker, activityType: activityType, categories: categories, documents: documents), decodeType: Profile.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Contact Us Information
    public func getContactUsInformation(success: @escaping (ContactUs) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getContactUsInformation, decodeType: ContactUs.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Create Payment Card
    public func createPaymentCard(with cardHolder: String, cardNumber: String, expirationDate: String, cvv: String, success: @escaping (PaymentCard) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .createPaymentCard(cardHolder: cardHolder, cardNumber: cardNumber, expirationDate: expirationDate, cvv: cvv), decodeType: PaymentCard.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Update Payment Card
    public func updatePaymentCard(with cardID: Int, cardHolder: String? = nil, isActive: Bool?, success: @escaping (PaymentCard) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .updatePaymentCard(cardID: cardID, cardHolder: cardHolder, isActive: isActive), decodeType: PaymentCard.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Payment Cards
    public func getPaymentCards(success: @escaping (PaymentCards) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getPaymentCards, decodeType: PaymentCards.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
//    // MARK: Edit User Profile
//    public func editUserProfile(with avatar: UIImage?, username: String, email: String, birthday: String, gender: GenderType, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .editUserProfile(avatar: avatar, username: username, email: email, birthday: birthday, gender: gender), decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Connect To Partner
//    public func connectToPartner(with code: String, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .connectToPartner(code: code), decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
//    // MARK: Post
//    public func post(with apnsToken: String, success: @escaping (Response) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.request(service: .post(apnsToken: apnsToken), decodeType: Response.self) { (result) in
//            switch result {
//            case .success(let response): success(response)
//            case .failure(let error): failure(error)
//            }
//        }
//    }
//    
    // MARK: Upload Files
    public func uploadFiles(with file: UIImage, type: FileType, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.uploadMultipartFormData(service: .uploadFiles(file: file, type: type), decodeType: String.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Languages
    public func getLanguages(success: @escaping (Languages) -> (), failure: @escaping (Error) -> ()) {
        serviceProvider.request(service: .getLanguages, decodeType: Languages.self) { (result) in
            switch result {
            case .success(let response): success(response)
            case .failure(let error): failure(error)
            }
        }
    }
    
    // MARK: Get Image
    public func getImage(with name: String, success: @escaping (UIImage?) -> (), failure: @escaping (Error) -> ()) {
        let url = "\(ConfigDataProvider.baseURL)/\(name)"
        serviceProvider.getImage(with: url, success: success, failure: failure)
    }
    
//    public func getImage(with url: String, success: @escaping (UIImage?) -> (), failure: @escaping (Error) -> ()) {
//        serviceProvider.getImage(with: url, success: success, failure: failure)
//    }
}
