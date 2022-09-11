//
//  Localization.swift
//  help.me
//
//  Created by Karen Galoyan on 11/19/21.
//

import Foundation

public enum Localization: String {
    case signIn_phoneNumberEmailUsername, signIn_password, signIn_signIn, signIn_forgotYourPassword, signIn_recoverIt, signIn_dontHaveAnAccount, signIn_signUp, signIn_or, signIn_enterAsGuest
    case recovery_email, recovery_sendLinkForNewPassword, recovery_dontHaveAnAccount, recovery_signUp, recovery_or, recovery_enterAsGuest, recovery_back
    case signUp_phoneNumberRequired, signUp_nameRequired, signUp_emailRequired, signUp_passwordRequired, signUp_confirmPasswordRequired, signUp_orGetInformationFrom, signUp_imUserWhoWantToHireWorker, signUp_alsoIwantToProvideService, signUp_individual, signUp_company, signUp_typeOfMyActivity, signUp_whatCanYouDo, signUp_youCanSelectThreeItems, signUp_addDocument, signUp_ifYouWantToBeMarkedUser, signUp_back, signUp_continue, signUp_save, signUp_iHaveAccept, signUp_licenseAgreements
    case phoneNumberVerification_phoneNumberVerification, phoneNumberVerification_getSmsVerificationCodeOn, phoneNumberVerification_getVerificationCode, phoneNumberVerification_done, phoneNumberVerification_back
    case biometricAuthorization_enableSignInWithTouchID, biometricAuthorization_enableSignInWithFaceID, biometricAuthorization_Yes, biometricAuthorization_No
    case licenseAgreement_licenseAgreement, licenseAgreement_accept
    case tabBar_Home, tabBar_Map, tabBar_Scan, tabBar_Chat, tabBar_Profile
    case home_lastWorks, home_topWorkersCompanies, home_topCategories, home_seeAll
    case notification_notifications, notification_emptyNotifications
    case story_readMore
    case seeAll_works, seeAll_workers, seeAll_categories, seeAll_last, seeAll_oldest, seeAll_nearByMe, seeAll_individual, seeAll_company, seeAll_verified, seeAll_new, seeAll_top
    case map_latest, map_nearByMe, map_byCategories, map_accept
    case offer_skipOffer, offer_apply
    case scan_captureAddCurrentJob
    case addWork_addNewWork, addWork_addCategoriesRequired, addWork_addLocationRequired, addWork_price, addWork_date, addWork_cash, addWork_addDescriptionRequired, addWork_retry, addWork_addWork
    case addPhoto_addNewPhoto, addPhoto_addCategoriesRequired, addPhoto_addDescriptionRequired, addPhoto_retry, addPhoto_addPhoto
    case profile_profilePage, profile_settings, profile_id, profile_gold, profile_silver, profile_bronze, profile_emptyPhotos, profile_addPhoto, profile_youDontHavePermissionToAddPhotos, profile_emptyWorks, profile_addWork, profile_youDontHavePermissionToAddWorks, profile_enableAlsoProvideServices, profile_active, profile_history, profile_creditCard, profile_addNew, profile_mobile, profile_eMail, profile_alsoProvideServices, profile_categories, profile_signInWithTouchID, profile_signInWithFaceID, profile_language, profile_contactUs, profile_termsConditions, profile_signOut
    case activeHistory_active, activeHistory_history
    case creditCard_creditDebitCard, creditCard_addNew, creditCard_description, creditCard_cardNumber, creditCard_expirationDate, creditCard_cvv, creditCard_cardholder, creditCard_apply
    case scanCreditCard_scanCreditDebitCard
    case phoneNumber_phoneNumber, phoneNumber_addNew, phoneNumber_description, phoneNumber_addNewPhoneNumber, phoneNumber_apply
    case email_email, email_addNew, email_description, email_addNewEmail, email_apply
    case language_languages
    case contactUs_contactUs
    var text: String {
        return self.rawValue.localized
    }
}
