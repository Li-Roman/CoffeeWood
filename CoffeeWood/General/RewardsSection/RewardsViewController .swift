//
//  Rewards .swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 06.08.2023.
//

import Foundation
import UIKit
import SnapKit

class RewardsViewController: UIViewController {

    let mainLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemYellow
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(100)
        }
        mainLabel.text = "Rewards Screen"
        mainLabel.font = .boldSystemFont(ofSize: 30)
        mainLabel.textColor = .black
        mainLabel.textAlignment = .center
    }

}

//class RewardsController: UIViewController {
//    
//    let presenter: RewardsPresenter
//    var collectionView: UICollectionView!
//    let refreshControl = UIRefreshControl()
//    
//    init(with presenter: RewardsPresenter) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = presenter.backgroundColor
//        setupCollectionView()
//        presenter.updateColors { [weak self] in
//            self?.collectionView.reloadData()
//        }
//        setupRefreshControl()
//    }
//    
//    func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        collectionView = UICollectionView(frame: self.view.frame,
//                                          collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = presenter
//        collectionView.refreshControl = refreshControl
//        presenter.registerCells(for: collectionView)
//        self.view.addSubview(collectionView)
//    }
//    
//    let layout: UICollectionViewFlowLayout = {
//      let layout = UICollectionViewFlowLayout()
////      let insetLeft: CGFloat = 5.0
////      let insetRight: CGFloat = 5.0
////      layout.sectionInset = UIEdgeInsets(top: 10,
////                                         left: 20,
////                                         bottom: 5.0,
////                                         right: 20)
//        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 20
//        
//        let itemWidth = UIScreen.main.bounds.width / 2 - (20 + 20)
//        layout.itemSize = CGSize(width: itemWidth, height: 300.0)
//      return layout
//    }()
//    
//    private func setupRefreshControl() {
//        let refresh = UIRefreshControl()
//        refresh.addTarget(self, action: #selector(refreshColors(sender:)), for: .valueChanged)
//    }
////    let refreshControl: UIRefreshControl = {
////        let refresh = UIRefreshControl ()
////        refresh.addTarget(RewardsController.self, action: #selector(RewardsController.refreshColors), for: .valueChanged)
////        return refresh
////    }()
//    
//    @objc func refreshColors(sender: AnyObject) {
//        // Если презентер вызывает комплишн из фонового потока, нам потребуется  вызывать релод из основного потока
//        presenter.updateColors { [weak self] in
//            DispatchQueue.main.async {
//                self?.collectionView.reloadData()
//                self?.refreshControl.endRefreshing()
//            }
//        }
//    }
//}
//
//
//extension RewardsController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
//    
//}
