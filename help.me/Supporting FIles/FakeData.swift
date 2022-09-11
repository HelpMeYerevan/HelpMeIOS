//
//  FakeData.swift
//  help.me
//
//  Created by Karen Galoyan on 11/25/21.
//

import Foundation
import UIKit

class FakeData {
    class var storiesDataSource: [StoryModel] {
        return [
            StoryModel(image: UIImage(named: "image_idram"), title: "Idram"),
            StoryModel(image: UIImage(named: "image_coca_cola"), title: "Coca Cola"),
            StoryModel(image: UIImage(named: "image_ucom"), title: "Ucom"),
            StoryModel(image: UIImage(named: "image_nissan"), title: "Nissan")
        ]
    }
    
    class var worksDataSource: [WorkModel] {
        return [
            WorkModel(image: UIImage(named: "image_wall"), categoryTitle: "Category", workerName: "Artur Petrsoyan", time: "3 min ago"),
            WorkModel(image: UIImage(named: "image_tv"), categoryTitle: "Category", workerName: "Artur Petrsoyan", time: "15 min ago"),
            WorkModel(image: UIImage(named: "image_flowers"), categoryTitle: "Category", workerName: "Artur Petrsoyan", time: "14:30"),
            WorkModel(image: UIImage(named: "image_bathroom"), categoryTitle: "Category", workerName: "Artur Petrsoyan", time: "15:35")
            
        ]
    }
    
    class var workersDataSource: [WorkerModel] {
        return [
            WorkerModel(image: UIImage(named: "image_worker_1"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6),
            WorkerModel(image: UIImage(named: "image_worker_2"), workerName: "Beatrice Avagimyan", categoryTitle: "Category name...", isVerified: true, rating: 4.6),
            WorkerModel(image: UIImage(named: "image_worker_3"), workerName: "Elina Asatryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6),
            WorkerModel(image: UIImage(named: "image_worker_4"), workerName: "Garik Vladimirovich", categoryTitle: "Category name...", isVerified: false, rating: 4.6),
            WorkerModel(image: UIImage(named: "image_worker_5"), workerName: "Vasya Petrovich", categoryTitle: "Category name...", isVerified: false, rating: 4.6),
            WorkerModel(image: UIImage(named: "image_worker_5"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6)
        ]
    }
    
    class var categoriesDataSource: [CategoryModel] {
        return [
            CategoryModel(title: "Electronic"),
            CategoryModel(title: "Garden"),
            CategoryModel(title: "Delivery"),
            CategoryModel(title: "Garden"),
            CategoryModel(title: "Cars"),
            CategoryModel(title: "Real estate")
        ]
    }
    
    class var chatDataSource: [ChatModel] {
        return [
            ChatModel(workImage: UIImage(named: "image_wall"), worker: WorkerModel(image: UIImage(named: "image_worker_1"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6), categoryName: "Category Name", messages: [MessageModel(message: "Barev dzez. Erb harmar klini handipenq?", time: "14:00", isOwnerMessage: false)], isActive: true, isUnread: true),
            ChatModel(workImage: UIImage(named: "image_tv"), worker: WorkerModel(image: UIImage(named: "image_worker_2"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6), categoryName: "Category Name", messages: [MessageModel(message: "Barev dzez", time: "14:00", isOwnerMessage: false)], isActive: true, isUnread: false),
            ChatModel(workImage: UIImage(named: "image_flowers"), worker: WorkerModel(image: UIImage(named: "image_worker_3"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6), categoryName: "Category Name", messages: [MessageModel(message: "Barev dzez", time: "14:00", isOwnerMessage: false)], isActive: true, isUnread: false),
            ChatModel(workImage: UIImage(named: "image_bathroom"), worker: WorkerModel(image: UIImage(named: "image_worker_4"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6), categoryName: "Category Name", messages: [MessageModel(message: "Barev dzez. Erb harmar klini handipenq?", time: "14:00", isOwnerMessage: false), MessageModel(message: "Barev dzez. Erb harmar klini handipenq?", time: "14:01", isOwnerMessage: false), MessageModel(message: "Barev dzez. esor\nharmar klini\nhandipenq ?", time: "14:01", isOwnerMessage: false), MessageModel(message: "Ha", time: "15:34", isOwnerMessage: true), MessageModel(message: "Karanq", time: "15:34", isOwnerMessage: true)], isActive: true, isUnread: false),
            ChatModel(workImage: UIImage(named: "image_wall"), worker: WorkerModel(image: UIImage(named: "image_worker_2"), workerName: "Karlen Grigoryan", categoryTitle: "Category name...", isVerified: false, rating: 4.6), categoryName: "Category Name", messages: [MessageModel(message: "Barev dzez. Erb harmar klini handipenq?", time: "14:00", isOwnerMessage: false), MessageModel(message: "Barev dzez. Erb harmar klini handipenq?", time: "14:01", isOwnerMessage: false), MessageModel(message: "Barev dzez. esor\nharmar klini\nhandipenq ?", time: "14:01", isOwnerMessage: false), MessageModel(message: "Ha", time: "15:34", isOwnerMessage: true), MessageModel(message: "Karanq", time: "15:34", isOwnerMessage: true)], isActive: false, isUnread: false)
        ]
    }
}

