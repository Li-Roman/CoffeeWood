import Foundation
import UIKit
 
class OrderConfirmationPresenter {
    
    weak var viewController: OrderConfirmationControllerInterface?
    
    private var user: DDUser? = nil
    private var cartPositions: [CartPosition]? = nil
    private var order: Order? = nil
    private var chosenCoffeeHouse: CoffeeHouseAnnotation? = nil
    private var coffeeHouses: [CoffeeHouseAnnotation]? = nil
    private var pickupTime: String? = nil
    
    deinit {
        print("OrderConfirmationPresenter is dead")
    }
    
    // MARK: - Private Methods
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        DatabaseService.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(user))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCartPositions() {
        if let user = self.user {
            getPositions(user.id)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getPositions(user.id)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getPositions(_ userID: String) {
        DatabaseService.shared.getCartPositions(from: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let positions):
                self.cartPositions = positions
                self.setTotalCostSectionView(with: positions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setTotalCostSectionView(with positions: [CartPosition]) {
        let totalPositionsCost = positions.reduce(0) { $0 + $1.cost}
        let taxCost = totalPositionsCost / 10
        let totalOrderCost = totalPositionsCost + taxCost
        viewController?.setTotalcostSectionWith(totalCost: totalOrderCost, subtotalCost: totalPositionsCost, taxCost: taxCost)
    }
    
    private func setOrder() {
        guard let coffeeHouse = self.chosenCoffeeHouse,
              let pickupTime = self.pickupTime,
              let positions = self.cartPositions else {
            // TODO: - Make Alert
            return
        }
        
        if let user = self.user {
            setOrderToCoffeeHouse(user: user,
                                  coffeeHouse: coffeeHouse,
                                  pickupTime: pickupTime,
                                  cartPositions: positions)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    setOrderToCoffeeHouse(user: user,
                                          coffeeHouse: coffeeHouse,
                                          pickupTime: pickupTime,
                                          cartPositions: positions)
                case .failure(let error):
                    self.showErrorSetOrderAlert(error: error)
                }
            }
        }
    }
    
    private func setOrderToUser(to user: DDUser, order: Order, coffeeHouse: CoffeeHouseAnnotation, pickupTime: String, cartPositions: [CartPosition]) {
        DatabaseService.shared.setOrderToUser(userID: user.id,
                                              order: order) { error in
            if let error = error {
                print(error.localizedDescription)
                // TODO: - Make alert somethigh goes wrong
                self.viewController?.stopAnimatePayButton(with: .failure, completion: {
                    self.viewController?.showAlert(self.setupFailureAlert(with: error))
                })
            }
        }
        cleanUsersCart(userID: user.id)
        viewController?.stopAnimatePayButton(with: .success, completion: {
            let tabbarController = GeneralTabBatController()
            tabbarController.selectedIndex = 1
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabbarController)
        })
    }
    
    private func setOrderToCoffeeHouse(user: DDUser, coffeeHouse: CoffeeHouseAnnotation, pickupTime: String, cartPositions: [CartPosition]) {
        let order = Order(userID: user.id,
                          cartPositions: cartPositions,
                          date: Date(),
                          address: coffeeHouse.address,
                          pickupTime: pickupTime,
                          status: .accepted)
        self.order = order
        
        DatabaseService.shared.setOrderToCoffeeHouse(id: coffeeHouse.id,
                                                     order: order) { error in
            if let error = error {
                // TODO: - Show Alert and return
                print(error.localizedDescription)
                self.viewController?.stopAnimatePayButton(with: .failure, completion: {
                    self.viewController?.showAlert(self.setupFailureAlert(with: error))
                })
                return
            }
        }
        setOrderToUser(to: user,
                       order: order,
                       coffeeHouse: coffeeHouse,
                       pickupTime: pickupTime,
                       cartPositions: cartPositions)
    }
    
    private func cleanUsersCart(userID: String) {
        let positions = order!.cartPositions
        for position in 0..<positions.count {
            deletePositionFromCart(positions[position].id)
        }
    }

    private func deletePositionFromCart(_ positionID: String) {
        if let user = self.user {
            removePosition(userID: user.id, positionID: positionID)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    removePosition(userID: user.id, positionID: positionID)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getAllCoffeeHouses(completion: @escaping (Result<[CoffeeHouseAnnotation], Error>) -> Void) {
        DatabaseService.shared.getAllCoffeeHouses { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coffeeHouses):
                self.coffeeHouses = coffeeHouses
                completion(.success(coffeeHouses))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // FIXME: - Make correct date and time adaptation
    private func getOpenTodayText(startHour: Double, endHour: Double) -> String {
        var result = ""
        let date = Date()
        
        let currentHour = date.get(.hour)
        
        switch (currentHour, startHour, endHour) {
        case (let x, _, let y) where x > Int(y):
            result = "CLosed today. Will open tomorrow at \(startHour)0"
        case (let x, let y, _) where x < Int(y):
            result = "Cafe for now. Will open today at \(startHour)0"
        default:
            result = "Open today until \(endHour)0"
        }
        
        return result
    }
    
    private func removePosition(userID: String, positionID: String) {
        DatabaseService.shared.deletePositionFromCart(userID: userID, positionID: positionID) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func showErrorSetOrderAlert(error: Error) {
        let alertTitle = "Something goes wrong"
        let alertMessage = "\(error.localizedDescription)"
        let okTitle = "Ok"
        let alertController = AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                                    alertMessage,
                                                                    okTitle,
                                                                    style: .alert, handler: nil)
        self.viewController?.showAlert(alertController)
    }
    
    private func showEmptyCartAlert() {
        let alertTitle = "Your cart is empty"
        let alertMessage = "Add at least 1 position to continue"
        let okTitle = "Ok"
        let alertController = AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                                    alertMessage,
                                                                    okTitle,
                                                                    style: .alert, handler: nil)
        viewController?.showAlert(alertController)
        
    }
    
    func setupFailureAlert(with error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "Something goes wrong",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Of", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
    
    private func showSuccessAddingOrder() {
        let alertTitle = "Success"
        let alertMessage = "We have already started to place your order"
        let okTitle = "Ok"
        let alertController = AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                                    alertMessage,
                                                                    okTitle,
                                                                    style: .alert) { action in
            let tabbarController = GeneralTabBatController()
            tabbarController.selectedIndex = 1
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabbarController)
        }
        self.viewController?.showAlert(alertController)
    }
    
    private func setupAdressPickerController() {
        if let dataSource = self.coffeeHouses {
            let addressPickerController = AddressPickerController(delegate: self,
                                                                  dataSource: dataSource)
            viewController?.showPopUp(for: addressPickerController)
        } else {
            getAllCoffeeHouses { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let coffeeHouces):
                    let addressPickerController = AddressPickerController(delegate: self,
                                                                          dataSource: coffeeHouces)
                    viewController?.showPopUp(for: addressPickerController)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - OrderConfirmationControllerDelegate
extension OrderConfirmationPresenter: OrderConfirmationControllerDelegate {
    func willShowCoffeeHouseAddress() {
        getAllCoffeeHouses { result in
            switch result {
            case .success(let coffeeHouses):
                self.chosenCoffeeHouse = coffeeHouses[0]
                let openTodayText = self.getOpenTodayText(startHour: coffeeHouses[0].startWorkingHour,
                                                          endHour: coffeeHouses[0].endWorkingHour)
                self.viewController?.setChosingAddress(address: coffeeHouses[0].address,
                                                       openTodayText: openTodayText)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func willShowPickupTime() {
        // TODO: - Get current time add 20 minutes, save into pickupTime and show
        let date = Date(timeIntervalSinceNow: 60 * 20)
        self.pickupTime = date.makeMeOnlyTime()
        viewController?.setChosingTime(time: pickupTime!)
    }
    
    func willChangeAddress() {
        setupAdressPickerController()
    }
    
    func willChangePickupTime() {
        // TODO: - Show all posiible variants
        var minDateComponents = DateComponents()
        minDateComponents.hour = 8
        minDateComponents.minute = 0
        var minDate = Calendar.current.date(from: minDateComponents)
        minDate = Date()
        
        var maxDateComponents = DateComponents()
        maxDateComponents.hour = 22
        maxDateComponents.minute = 0
        let maxDate = Calendar.current.date(from: maxDateComponents)
        
        let datePicker = TimePickerController(delegate: self,
                                              minTime: countMinTime(),
                                              maxTime: maxDate!,
                                              showTime: countShowingTime())
        
        viewController?.showPopUp(for: datePicker)
    }
    
    private func countMinTime() -> Date {
        let currentDate = Date()
        let minutes = currentDate.get(.minute)
        
        if minutes % 10 == 0 {
            let dateToReturn = Calendar.current.date(byAdding: .minute, value: 0, to: currentDate)!
            return dateToReturn
        } else {
            let minutes = (minutes % 10) + (10 - minutes % 10)
            let dateToReturn = Calendar.current.date(byAdding: .minute, value: minutes, to: currentDate)!
            return dateToReturn
        }
    }
    
    private func countShowingTime() -> Date {
        let date = countMinTime()
        let minutes = countMinTime().get(.minute)
        let hours = countMinTime().get(.hour)
        
        if minutes + 20 > 60 {
            return Calendar.current.date(byAdding: .minute, value: 20, to: date)!
        } else {
            let date = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
            return Calendar.current.date(byAdding: .minute, value: minutes + 20 - 60, to: date)!
        }
    }
    
    func willSetOrder() {
        viewController?.startAnimatePayButton()
        setOrder()
    }
    
    func willShowTotoalCostSection() {
        getCartPositions()
    }
}

// MARK: - AddressPickerControllerDelegate
extension OrderConfirmationPresenter: AddressPickerControllerDelegate {
    func didSelect(coffeeHouse: CoffeeHouseAnnotation) {
        self.chosenCoffeeHouse = coffeeHouse
        let openTodayText = getOpenTodayText(startHour: coffeeHouse.startWorkingHour,
                                             endHour: coffeeHouse.endWorkingHour)
        viewController?.setChosingAddress(address: coffeeHouse.address, openTodayText: openTodayText)
    }
}

// MARK: - TimePickerControllerDelegate
extension OrderConfirmationPresenter: TimePickerControllerDelegate {
    func didSelect(time: Date) {
        let time = time.makeMeOnlyTime()
        self.pickupTime = time
        viewController?.setChosingTime(time: time)
    }
}
