//
//  MyOrderView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol MyOrdersViewDelegate: AnyObject {
    func willShowOnGoingOrders()
    func willShowHistoryOrders()
}

class MyOrdersView: UIView {
    
    weak var delegate: MyOrdersViewDelegate?
    
    private var dataSurce = [Order]()
    
    private let myOrdersLabel = UILabel()
    private let onGoingButton = UIButton()
    private let historyButton = UIButton()
    private let headerLineView = UIView()
    private let sectionUnderlineView = UIView()
    private let ordersTableView = UITableView(frame: .zero, style: .plain)
    
    init(delegate: MyOrdersViewDelegate) {
        self.delegate = delegate
        delegate.willShowOnGoingOrders()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Internal Methods
    func presentOrders(orders: [Order]) {
        self.dataSurce = orders
        
        DispatchQueue.main.async {
            print("reload Data in MyOrdersView")
            self.ordersTableView.reloadData()
        }
    }
    
    // MARK: - Provate Methods
    private func makeMeSelected(button: UIButton) {
        button.configuration?.baseForegroundColor = AppColors.Buttons.TextButton.darkBlue
    }
    
    private func makeMeUnSelected(button: UIButton) {
        button.configuration?.baseForegroundColor = AppColors.Buttons.TextButton.lightGray
    }
    
    private func changeUnderlinePosition(sender: UIButton) {
        let dif = self.sectionUnderlineView.frame.width - sender.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.curveEaseInOut]) {
            self.sectionUnderlineView.frame.origin.x = sender.frame.origin.x - dif / 2
        } completion: { _ in
            self.sectionUnderlineView.frame.origin.x = sender.frame.origin.x - dif / 2
        }
    }
}

// MARK: - Setup View
extension MyOrdersView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupMyOrdersLabel()
        setupOnGoingButton()
        setupHistoryButton()
        setupHeaderLineView()
        setupSectionUnderlineView()
        setupOrdersTableView()
    }
    
    private func setupMyOrdersLabel() {
        myOrdersLabel.text = Resources.Strings.MyOrders.myOrdersLabel
        myOrdersLabel.font = Resources.Font.MyOrders.myOrdersLabel
        myOrdersLabel.textColor = AppColors.Labels.darkBlue
        myOrdersLabel.textAlignment = .center
        
        addSubview(myOrdersLabel)
        myOrdersLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(60)
            make.width.equalTo(100)
            make.height.equalTo(26)
        }
    }
    
    private func setupOnGoingButton() {
        onGoingButton.configuration = .borderless()
        
        var container = AttributeContainer()
        container.font = Resources.Font.MyOrders.onGoingTitle
        
        let onGoingString = AttributedString(Resources.Strings.MyOrders.onGoingTitle, attributes: container)
        
        onGoingButton.configuration?.attributedTitle = onGoingString
        onGoingButton.configuration?.titleAlignment = .center
        onGoingButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.white
        onGoingButton.configuration?.baseForegroundColor = AppColors.Buttons.TextButton.darkBlue
        onGoingButton.addTarget(self, action: #selector(onGoingButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(onGoingButton)
        onGoingButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(60)
            make.top.equalToSuperview().inset(114)
            make.width.equalTo(93)
            make.height.equalTo(21)
        }
    }
    
    private func setupHistoryButton() {
        historyButton.configuration = .borderless()
        
        var container = AttributeContainer()
        container.font = Resources.Font.MyOrders.historyTitle
        
        let onGoingString = AttributedString(Resources.Strings.MyOrders.historyTitle, attributes: container)
        
        historyButton.configuration?.attributedTitle = onGoingString
        historyButton.configuration?.titleAlignment = .center
        historyButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.white
        historyButton.configuration?.baseForegroundColor = AppColors.Buttons.TextButton.lightGray
        historyButton.addTarget(self, action: #selector(historyButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(historyButton)
        historyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(60)
            make.top.equalToSuperview().inset(114)
            make.width.equalTo(93)
            make.height.equalTo(21)
        }
    }
    
    private func setupHeaderLineView() {
        headerLineView.backgroundColor = AppColors.Lines.lightGray
        
        addSubview(headerLineView)
        headerLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(onGoingButton.snp_bottomMargin).inset(-28)
            make.height.equalTo(1)
        }
    }
    
    private func setupSectionUnderlineView() {
        sectionUnderlineView.backgroundColor = AppColors.Lines.darkBlue
        sectionUnderlineView.layer.cornerRadius = 2
        
        addSubview(sectionUnderlineView)
        sectionUnderlineView.snp.makeConstraints { make in
            make.bottom.equalTo(headerLineView)
            make.height.equalTo(2)
            make.width.equalTo(114)
            make.centerX.equalTo(onGoingButton.snp_centerXWithinMargins)
        }
    }
    
    private func setupOrdersTableView() {
        ordersTableView.register(MyOrdersTableViewCell.self, forCellReuseIdentifier: "MyOrdersTableViewCell")
        
        ordersTableView.backgroundColor = .systemBackground
        ordersTableView.separatorColor = AppColors.Lines.lightGray
        
        ordersTableView.showsVerticalScrollIndicator = false
        ordersTableView.allowsSelection = false
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        ordersTableView.rowHeight = 100
        
        addSubview(ordersTableView)
        ordersTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(headerLineView).inset(18)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Actions
extension MyOrdersView {
    @objc private func onGoingButtonAction(sender: UIButton) {
        delegate?.willShowOnGoingOrders()
        
        makeMeSelected(button: sender)
        makeMeUnSelected(button: historyButton)
        changeUnderlinePosition(sender: sender)
    }
    
    @objc private func historyButtonAction(sender: UIButton) {
        delegate?.willShowHistoryOrders()
        
        makeMeSelected(button: sender)
        makeMeUnSelected(button: onGoingButton)
        changeUnderlinePosition(sender: sender)
    }
}

// MARK: - UITableViewDataSource
extension MyOrdersView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSurce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as? MyOrdersTableViewCell else {
            fatalError()
        }
        cell.configureCell(with: dataSurce[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyOrdersView: UITableViewDelegate {
    
}
