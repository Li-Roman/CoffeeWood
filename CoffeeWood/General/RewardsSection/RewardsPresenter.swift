////
////  RewardsPresenter.swift
////  CoffeeWood
////
////  Created by Роман Хилюк on 09.08.2023.
////
//
//import Foundation
//import UIKit
//
//class ColorModel {
//    typealias UpdateColorsCompletion = () -> ()
//    var colors: [UIColor] = []
//
//    func updateColors(completion: @escaping UpdateColorsCompletion) {
//        self.colors = RandomColors.shareRandomColor(from: colorStorage)
//        // Этот запрос мы будет выполнять в основном потоке, но реальный сетевой запрос нужно вызывать в фоновом режиме
//        completion()
//    }
//
//    private let colorStorage: [UIColor] = [
//        .black,
//        .blue,
//        .brown,
//        .cyan,
//        .darkGray,
//        .green,
//        .red,
//        .yellow,
//        .orange
//    ]
//}
//
//class RandomColors {
//    static func shareRandomColor(from colors: [UIColor]) -> [UIColor] {
//        var result = [UIColor]()
//        for _ in 0..<14 {
//            result.append(colors[Int.random(in: 0..<colors.count)])
//        }
//        return result
//    }
//}
//
//
//
//
//
//
//
//
//
//
//class RewardsPresenter: NSObject {
//    let model = ColorModel()
//    let backgroundColor = UIColor.white
//    private var colors: [UIColor] {
//        return model.colors
//    }
//    private let cellIdentifier = "DefaultCell"
//
//    // Чтобы использоать наше приложение, нам нужно запросить данные у модели. ЧТобы дать возможность делать это, добавим мновый метод в презентер
//    // Он вызывает метод обновления в модели и передаст завершение вверх по цепочке
//    func updateColors(completion: @escaping (() -> ())) {
//        // Запросим данные при загрузке представления и перезагрузим представление коллекции по завершении (в комплишене)
//        self.model.updateColors {
//            completion()
//        }
//    }
//
//    func registerCells (for collectionView: UICollectionView) {
//        collectionView.register(UICollectionViewCell.self,
//        forCellWithReuseIdentifier: cellIdentifier)
//    }
//}
//
//extension RewardsPresenter: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return colors.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
//        cell.contentView.backgroundColor = colors[indexPath.row]
//        cell.contentView.layer.cornerRadius = 20.0
//        return cell
//    }
//}
