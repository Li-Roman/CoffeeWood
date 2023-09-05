import Foundation
import UIKit
import SnapKit

protocol HomeViewDelegate: AnyObject {
    func didTappedCartButton()
    func didTappedProfileButton()
    func willShowUsername()
    func willShowCoffeeProducts()
    func willShowCartCountLabel()
    func didlSelectCoffeeProduct(_ coffeeProduct: CoffeeProduct)
}

class HomeView: UIView {
    
    // MARK: - delegate
    weak var delegate: HomeViewDelegate?
    
    // MARK: - Private Propeties
    private let loyalityCount: Int = 1
    private var dataSource = [CoffeeProduct]()
    
    // MARK: - Views
    private let loyalityBackView = UIView()
    private let loyalityCupsBackView = UIView()
    private let collectionBackView = UIView()
    private var cartPositionsCountView: CartPositionsCountView?
    
    // MARK: - ColletionView
    private var coffeeColletionView: UICollectionView!
    
    // MARK: - Buttons
    private let cartButton = UIButton()
    private let profileButton = UIButton()
    
    // MARK: - Labels
    private let goodDayLabel = UILabel()
    private let nameLabel = UILabel()
    private let loyalitytCardLabel = UILabel()
    private let chooseCoffeeLabel = UILabel()
    private let loyalityCountLabel = UILabel()
    
    // MARK: - StackView
    private var loyalityCupsStack = UIStackView()
    
    // MARK: - Initialize
    init(delegate: HomeViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeView is dead")
    }
    
    // MARK: - Internal Methods
    func presentProducts(_ products: [CoffeeProduct]) {
        print("presentProducts in HomeView")
        self.dataSource = products
        
        DispatchQueue.main.async {
            self.coffeeColletionView.reloadData()
            print("reload data")
        }
    }
    
    func presentUsername(_ username: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = username
        }
    }
    
    func updateCartLabelCount(isHidden: Bool, count: Int) {
        DispatchQueue.main.async {
            self.cartPositionsCountView?.isHidden = isHidden
            self.cartPositionsCountView?.updateCountNumber(for: count)
        }
    }
    
    // MARK: - Private Methods
    private func setLoyalityCountLabel() -> String {
        return "\(loyalityCount) / 8"
    }
    
    private func makeCups(_ count: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = count <= loyalityCount ? UIImage(named: "cupActive")! : UIImage(named: "cupInactive")!
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 163, height: 174)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        return layout
    }
}

// MARK: - Setup View
private extension HomeView {
    func setupView() {
        backgroundColor = AppColors.Background.whiteBack
        
        setupLoyalityBackView()
        setupLoyalityCupsBackView()
        setupCollectionBackView()
        setupCartButton()
        setupCartPositionsCountView()
        setupProfileButton()
        setupCoffeeColletionView()
        setupGoodDayLabel()
        setupnNameLabel()
        setupLoyalitytCardLabel()
        setupChooseCoffeeLabel()
        setupLoyalityCountLabel()
        setupLoyalityCupsStack()
    }
    
    func setupLoyalityBackView() {
        loyalityBackView.backgroundColor = AppColors.Background.blueBack
        loyalityBackView.layer.cornerRadius = 14
        
        addSubview(loyalityBackView)
        loyalityBackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(134)
            make.width.equalTo(340)
            make.height.equalTo(126)
        }
    }
    
    func setupLoyalityCupsBackView() {
        loyalityCupsBackView.backgroundColor = AppColors.Background.whiteBack
        loyalityCupsBackView.layer.cornerRadius = 15
        
        loyalityBackView.addSubview(loyalityCupsBackView)
        loyalityCupsBackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(18)
            make.width.equalTo(294)
            make.height.equalTo(62)
        }
    }
    
    func setupCollectionBackView() {
        collectionBackView.backgroundColor = AppColors.Background.blueBack
        collectionBackView.layer.cornerRadius = 30
        
        addSubview(collectionBackView)
        collectionBackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(-30)
            make.left.right.equalToSuperview()
            make.top.equalTo(loyalityBackView.snp_bottomMargin).inset(-50)
        }
    }
    
    func setupCartButton() {
        cartButton.setImage(Resources.Images.HomePage.cart, for: .normal)
        cartButton.backgroundColor = AppColors.Buttons.Back.white
        cartButton.imageView?.contentMode = .scaleAspectFit
        cartButton.addTarget(self, action: #selector(cartButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(cartButton)
        cartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(78)
            make.right.equalToSuperview().inset(86)
            make.height.width.equalTo(22)
        }
    }
    
    func setupCartPositionsCountView() {
        cartPositionsCountView = CartPositionsCountView(delegate: self)
        cartPositionsCountView!.isHidden = true
        cartPositionsCountView!.layer.cornerRadius = 9
        cartPositionsCountView!.clipsToBounds = true
        
        delegate?.willShowCartCountLabel()
        
        addSubview(cartPositionsCountView!)
        cartPositionsCountView!.snp.makeConstraints { make in
            make.top.equalTo(cartButton).inset(-8)
            make.right.equalTo(cartButton).inset(-8)
            make.height.width.equalTo(18)
        }
    }
    
    func setupProfileButton() {
        profileButton.setImage(Resources.Images.HomePage.profile, for: .normal)
        profileButton.backgroundColor = AppColors.Buttons.Back.white
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.addTarget(self, action: #selector(profileButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(profileButton)
        profileButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(76)
            make.right.equalToSuperview().inset(36)
            make.height.width.equalTo(22)
        }
    }
    
    func setupGoodDayLabel() {
        goodDayLabel.text = Resources.Strings.HomaPage.goodDay
        goodDayLabel.font = Resources.Font.HomePage.goodDay
        goodDayLabel.textColor = AppColors.Labels.lightGray
        goodDayLabel.textAlignment = .left
        
        addSubview(goodDayLabel)
        goodDayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(68)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
    }
    
    func setupnNameLabel() {
        delegate?.willShowUsername()
        
//        nameLabel.text = userName
        nameLabel.font = Resources.Font.HomePage.name
        nameLabel.textColor = AppColors.Labels.darkBlue
        nameLabel.textAlignment = .left
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(26)
            make.top.equalToSuperview().inset(90)
            make.width.equalTo(150)
            make.height.equalTo(26)
        }
    }
    
    func setupLoyalitytCardLabel() {
        loyalitytCardLabel.text = Resources.Strings.HomaPage.loyalityCard
        loyalitytCardLabel.font = Resources.Font.HomePage.loyalityCard
        loyalitytCardLabel.textColor = AppColors.Labels.lightGray
        loyalitytCardLabel.textAlignment = .left
        
        loyalityBackView.addSubview(loyalitytCardLabel)
        loyalitytCardLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(14)
            make.width.equalTo(120)
            make.height.equalTo(22)
        }
    }
    
    func setupLoyalityCountLabel() {
        loyalityCountLabel.text = setLoyalityCountLabel()
        loyalityCountLabel.font = Resources.Font.HomePage.loyalityCount
        loyalityCountLabel.textColor = AppColors.Labels.lightGray
        loyalityCountLabel.textAlignment = .right
        
        loyalityBackView.addSubview(loyalityCountLabel)
        loyalityCountLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(14)
            make.width.equalTo(120)
            make.height.equalTo(22)
        }
    }
    
    func setupLoyalityCupsStack() {
        let arr = [1, 2, 3, 4, 5, 6, 7, 8]
        loyalityCupsStack = UIStackView(arrangedSubviews: arr.map { makeCups($0) })
        
        loyalityCupsBackView.addSubview(loyalityCupsStack)
        loyalityCupsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        loyalityCupsStack.axis = .horizontal
        loyalityCupsStack.spacing = 10
        loyalityCupsStack.alignment = .center
        loyalityCupsStack.distribution = .fillEqually
        
    }
    
    func setupChooseCoffeeLabel() {
        chooseCoffeeLabel.text = Resources.Strings.HomaPage.chooseCoffe
        chooseCoffeeLabel.font = Resources.Font.HomePage.chooseCoffe
        chooseCoffeeLabel.textColor = AppColors.Labels.lightGray
        chooseCoffeeLabel.textAlignment = .left
        
        collectionBackView.addSubview(chooseCoffeeLabel)
        chooseCoffeeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.top.equalToSuperview().inset(24)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }
    
    func setupCoffeeColletionView() {
        coffeeColletionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        
        coffeeColletionView.dataSource = self
        coffeeColletionView.delegate = self
        coffeeColletionView.backgroundColor = AppColors.Background.blueBack
        coffeeColletionView.showsVerticalScrollIndicator = false
        
        print("willShowCoffeeProducts in view")
        delegate?.willShowCoffeeProducts()
        
        coffeeColletionView.register(CoffeeProductCollectionViewCell.self, forCellWithReuseIdentifier: "\(CoffeeProductCollectionViewCell.self)")
        
        collectionBackView.addSubview(coffeeColletionView)
        coffeeColletionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(76)
            make.bottom.equalToSuperview().inset(140)
        }
    }
}

// MARK: - Actions
private extension HomeView {
    @objc func profileButtonAction(sender: UIButton) {
        print("profile Button did tapped")
        delegate?.didTappedProfileButton()
    }
    
    @objc func cartButtonAction(sender: UIButton) {
        print("cart button did tapped")
        delegate?.didTappedCartButton()
    }
}


// MARK: - UICollectionViewDataSource
extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = coffeeColletionView.dequeueReusableCell(withReuseIdentifier: "\(CoffeeProductCollectionViewCell.self)", for: indexPath) as? CoffeeProductCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(with: dataSource[indexPath.item])
        
        return cell
    }
}

// MARK: - UIColletionViewDelegate
extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didlSelectCoffeeProduct(dataSource[indexPath.row])
    }
}

// MARK: -
extension HomeView: CartPositionsCountViewDelegate {
    func didTapAction() {
        delegate?.didTappedCartButton()
    }
}
