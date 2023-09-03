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
    private let activeButton = UIButton()
    private let completedButton = UIButton()
    private let headerLineView = UIView()
    private let sectionUnderlineView = UIView()
    private let ordersTableView = UITableView(frame: .zero, style: .plain)
    
    init(delegate: MyOrdersViewDelegate) {
        self.delegate = delegate
        delegate.willShowOnGoingOrders()
        super.init(frame: .zero)
        setupView()
        setupGestureRecognizer()
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
    
    private func changeUnderlinePosition(to button: UIButton) {
        let dif = self.sectionUnderlineView.frame.width - button.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.curveEaseInOut]) {
            self.sectionUnderlineView.frame.origin.x = button.frame.origin.x - dif / 2
        } completion: { _ in
            self.sectionUnderlineView.frame.origin.x = button.frame.origin.x - dif / 2
        }
    }
    
    private func setupGestureRecognizer() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(historyButtonAction))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(activeButtonAction))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }
}

// MARK: - Setup View
extension MyOrdersView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupMyOrdersLabel()
        setupActiveButton()
        setupCompletedButton()
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
    
    private func setupActiveButton() {
        activeButton.configuration = .borderless()
        
        var container = AttributeContainer()
        container.font = Resources.Font.MyOrders.onGoingTitle
        
        let onGoingString = AttributedString(Resources.Strings.MyOrders.onGoingTitle, attributes: container)
        
        activeButton.configuration?.attributedTitle = onGoingString
        activeButton.configuration?.titleAlignment = .center
        activeButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.white
        activeButton.configuration?.baseForegroundColor = AppColors.Buttons.TextButton.darkBlue
        activeButton.addTarget(self, action: #selector(activeButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(activeButton)
        activeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(60)
            make.top.equalToSuperview().inset(114)
            make.width.equalTo(93)
            make.height.equalTo(21)
        }
    }
    
    private func setupCompletedButton() {
        completedButton.configuration = .borderless()
        
        var container = AttributeContainer()
        container.font = Resources.Font.MyOrders.historyTitle
        
        let onGoingString = AttributedString(Resources.Strings.MyOrders.historyTitle, attributes: container)
        
        completedButton.configuration?.attributedTitle = onGoingString
        completedButton.configuration?.titleAlignment = .center
        completedButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.white
        completedButton.configuration?.baseForegroundColor = AppColors.Buttons.TextButton.lightGray
        completedButton.addTarget(self, action: #selector(historyButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(completedButton)
        completedButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(60)
            make.top.equalToSuperview().inset(114)
            make.width.equalTo(110)
            make.height.equalTo(21)
        }
    }
    
    private func setupHeaderLineView() {
        headerLineView.backgroundColor = AppColors.Lines.lightGray
        
        addSubview(headerLineView)
        headerLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(activeButton.snp_bottomMargin).inset(-28)
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
            make.centerX.equalTo(activeButton.snp_centerXWithinMargins)
        }
    }
    
    private func setupOrdersTableView() {
        ordersTableView.register(MyOrdersTableViewCell.self, forCellReuseIdentifier: "MyOrdersTableViewCell")
        
        ordersTableView.backgroundColor = .systemBackground
        ordersTableView.separatorColor = AppColors.Lines.gray
        
        ordersTableView.showsVerticalScrollIndicator = false
        ordersTableView.allowsSelection = false
        ordersTableView.dataSource = self
        
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
    @objc private func activeButtonAction(sender: Any) {
        delegate?.willShowOnGoingOrders()
        
        makeMeSelected(button: activeButton)
        makeMeUnSelected(button: completedButton)
        changeUnderlinePosition(to: activeButton)
    }
    
    @objc private func historyButtonAction(sender: Any) {
        delegate?.willShowHistoryOrders()
        
        makeMeSelected(button: completedButton)
        makeMeUnSelected(button: activeButton)
        changeUnderlinePosition(to: completedButton)
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
