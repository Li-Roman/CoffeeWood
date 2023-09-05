import Foundation
import UIKit

enum Resources {
    // MARK: - String
    enum Strings {
        enum TabBar {
            static let homeSection = "Home"
            static let rewardsSection = "Rewards"
            static let orderSection = "Order"
        }
        
        enum HomaPage {
            static let goodDay = "Good morning"
            static let loyalityCard = "Loyality card"
            static let chooseCoffe = "Choose your coffee"
        }
        
        enum Details {
            static let detailsLabel = "Details"
            static let singleButton = "Single"
            static let doubleButton = "Double"
            static let shotSectionLabel = "Shot"
            static let temperatureLabel = "Select"
            static let sizeSectionLabel = "Size"
            static let iceSectionLabel = "Ice"
            static let totalAmountLabel = "Total Amount"
            static let checkountButton = "Checkout"
        }
        
        enum MyCart {
            static let myCartLabel = "My Cart"
            static let totalPriceLabel = "Total Price"
            static let checkoutButton = "Checkout"
        }
        
        enum MyOrders {
            static let myOrdersLabel = "My Orders"
            static let onGoingTitle = "Active"
            static let historyTitle = "History"
        }
        
        enum OrderConfirmation {
            static let orderConfirmationLabel = "Order Confirmation"
            static let chooseAddressAndTimaLabel = "Choose Address and Time"
            static let subtotalLabel = "Subtotal"
            static let onlineBankingMainLabel = "Online Banking"
            static let creditCardMainLabel = "Credit Card"
            static let onlineBankingSubLabel = "maybank2u (one-time)"
            static let creditCardSubLabel = "2540 xxxx xxxx 2648"
            static let taxLabel = "Tax(10%)"
            static let deliveryFee = "Delivery fee"
            static let deliveryFeeCost = "$2.00"
            static let totalPriceLabel = "Total Price"
            static let payNowButton = "Pay Now"
        }
        
        enum CoffeeHouseController {
            static let acceptedLabel = "Accepted"
            static let preparingLabel = "Preparing"
            static let estimatedPickupLabel = "Estimated pickup time"
            static let emptyOrderTitle = "Here will be your order status"
        }
    }
    
    // MARK: - Images
    enum Images {
        enum TabBar {
            static let homeSection = UIImage(named: "home_tab")!
            static let rewardSection = UIImage(named: "map_tab")!
            static let orderSection = UIImage(named: "order_tab")!
        }
        
        enum HomePage {
            static let cart = UIImage(named: "Cart")!
            static let profile = UIImage(named: "person.png")!
        }
        
        enum Details {
            static let backArrowButton = UIImage(systemName: "arrow.left")!
            static let cartButton = UIImage(named: "Cart")!
            static let hotButtonInactive = UIImage(named: "hotType")
            static let iceButtonInactive = UIImage(named: "iceType")
            static let hotButtonActive = UIImage(named: "hotType.active")
            static let iceButtonActive = UIImage(named: "iceType.active")
            static let sizeTypeButton = UIImage(named: "cupSize")
            static let sizeTypeButtonActive = UIImage(named: "cupSize.active")
            static let littleIced = UIImage(named: "littleIced")
            static let halfIced = UIImage(named: "halfIced")
            static let fullIced = UIImage(named: "fullIced")
            static let littleIcedActive = UIImage(named: "littleIced.active")
            static let halfIcedActive = UIImage(named: "halfIced.active")
            static let fullIcedActive = UIImage(named: "fullIced.active")
        }
        
        enum MyCart {
            static let checkoutButton = UIImage(named: "cart.button")
            static let deleteTableCell = UIImage(named: "Clear")
        }
        
        enum OrdersTableView {
            static let coffeeCup = UIImage(named: "CoffeeCupIcon")
            static let geoPoint = UIImage(named: "GeoPoint")
        }
        
        enum OrderConfirmation {
            static let addressImage = UIImage(named: "home")
            static let workingHoursImage = UIImage(systemName: "clock")
            static let onlineBankImage = UIImage(named: "onlineBank")
            static let credicCardPayment = UIImage(named: "creditCard.payment")
            static let paymentImage = UIImage(named: "payment")
            static let chosingCircle = UIImage(named: "chosingCircle")
        }
        
        enum CoffeeHouseController {
            static let coffeeHouseIcon = UIImage(named: "coffeeHouseIcon")
            static let routeButton = UIImage(named: "route")
            static let callButton = UIImage(named: "phoneHandset.png")
            static let emptyOrderImageView = UIImage(named: "list")
            static let acceptedImageView = UIImage(named: "list")
            static let preparingImageView = UIImage(named: "coffeePreparing")
            static let completedImageVIew = UIImage(named: "cupSize")
        }
    }
    
    // MARK: - Font
    enum Font {
        enum HomePage {
            static let goodDay = UIFont(name: "Poppins-Medium", size: 15)
            static let name = UIFont(name: "Poppins-Medium", size: 19)
            static let loyalityCard = UIFont(name: "Poppins-Medium", size: 15)
            static let loyalityCount = UIFont(name: "Poppins-Medium", size: 15)
            static let chooseCoffe = UIFont(name: "Poppins-Medium", size: 17)
            static let coffeeProduct = UIFont(name: "DMSans-Medium", size: 15)
        }
        
        enum Details {
            static let detailsLabel = UIFont(name: "Poppins-Medium", size: 17)
            static let quanitySectionLabel = UIFont(name: "DMSans-Bold", size: 17)
            static let temperatureLabel = UIFont(name: "DMSans-Medium", size: 15)
            static let cupSizeLabel = UIFont(name: "DMSans-Medium", size: 15)
            static let shotSectionLabel = UIFont(name: "DMSans-Medium", size: 15)
            static let iceSectionLabel = UIFont(name: "DMSans-Medium", size: 15)
            static let shotButton = UIFont(name: "DMSans-Medium", size: 13)
            static let totalAmount = UIFont(name: "Poppins-Medium", size: 17)
            static let totalCostLabel = UIFont(name: "Poppins-SemiBold", size: 17)
            static let checkoutButton = UIFont(name: "Poppins-SemiBold", size: 15)
        }
        
        enum MyCart {
            static let myCartLabel = UIFont(name: "Poppins-Medium", size: 22)
            static let totalPriceLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let totalCostLabel = UIFont(name: "Poppins-SemiBold", size: 23)
            static let checkoutButton = UIFont(name: "Poppins-SemiBold", size: 15)
        }
        
        enum MyOrders {
            static let myOrdersLabel = UIFont(name: "Poppins-Medium", size: 17)
            static let onGoingTitle = UIFont(name: "Poppins-Medium", size: 15)
            static let historyTitle = UIFont(name: "Poppins-Medium", size: 15)
        }
        
        enum OrdersTableView {
            static let productNameLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let addressLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let dateLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let productsCostLabel = UIFont(name: "Poppins-Medium", size: 16)
        }
        
        enum CartTableView {
            static let productNameLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let productDescriptionLabel = UIFont(name: "Poppins-Light", size: 10)
            static let productPriceLabel = UIFont(name: "Poppins-Medium", size: 17)
            static let productsCountLabel = UIFont(name: "Poppins-SemiBold", size: 13)
        }
        
        enum OrderConfirmation {
            static let orderConfirmationLabel = UIFont(name: "Poppins-Medium", size: 22)
            static let chooseAddressAndTimaLabel = UIFont(name: "Poppins-Medium", size: 15)
            static let addressLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let workingHoursLabel = UIFont(name: "Poppins-Light", size: 12)
            static let subtotalConsLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let paymenstMainLabel = UIFont(name: "Poppins-Medium", size: 15)
            static let paymenstSubLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let subtotalLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let subtotalCostLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let taxLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let taxCostLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let totalPriceLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let totalCostLabel = UIFont(name: "Poppins-SemiBold", size: 23)
            static let payNowButton = UIFont(name: "Poppins-SemiBold", size: 14)
        }
        
        enum CoffeeHouseController {
            static let mainLabel = UIFont(name: "Poppins-SemiBold", size: 16)
            static let addressLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let acceptedLabel = UIFont(name: "Poppins-SemiBold", size: 16)
            static let preparingLabel = UIFont(name: "Poppins-SemiBold", size: 16)
            static let estimatedPickupLabel = UIFont(name: "Poppins-SemiBold", size: 16)
            static let emptyOrderLabel = UIFont(name: "Poppins-SemiBold", size: 18)
        }
    }
}
