//
//  Resources.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 06.08.2023.
//

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
            static let onGoingTitle = "On going"
            static let historyTitle = "History"
        }
        
        enum OrderConfirmation {
            static let orderConfirmationLabel = "Order Confirmation"
            static let deliveryAddress = "Delivery Address"
            static let subtotalLabel = "Subtotal"
            static let taxLabel = "Tax(10%)"
            static let deliveryFee = "Delivery fee"
            static let deliveryFeeCost = "$2.00"
            static let totalPriceLabel = "Total Price"
            static let payNowButton = "Pay Now"
        }
    }
    
    // MARK: - Images
    enum Images {
        enum TabBar {
            static let homeSection = UIImage(named: "home_tab")!
            static let rewardSection = UIImage(named: "reward_tab")!
            static let orderSection = UIImage(named: "order_tab")!
        }
        
        enum HomePage {
            static let cart = UIImage(named: "Cart")!
            static let profile = UIImage(named: "Person")!
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
            static let deliveryImage = UIImage(named: "delivery")
            static let editImage = UIImage(named: "Edit")
            static let onlineBankImage = UIImage(named: "onlineBank")
            static let masterCardImage = UIImage(named: "masterCard")
            static let visaImage = UIImage(named: "visa")
            static let paymentImage = UIImage(named: "payment")
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
            static let productNameLabel = UIFont(name: "Poppins-Medium", size: 10)
            static let addressLabel = UIFont(name: "Poppins-Medium", size: 10)
            static let dateLabel = UIFont(name: "Poppins-Medium", size: 10)
            static let productsCostLabel = UIFont(name: "Poppins-Medium", size: 16)
        }
        
        enum CartTableView {
            static let productNameLabel = UIFont(name: "Poppins-Medium", size: 13)
            static let productDescriptionLabel = UIFont(name: "Poppins-Light", size: 10)
            static let productPriceLabel = UIFont(name: "Poppins-Medium", size: 17)
            static let productsCountLabel = UIFont(name: "Poppins-SemiBold", size: 13)
        }
        
        enum OrderConfirmation {
            static let orderConfirmationLabel = UIFont(name: "Poppins-Medium", size: 21)
            static let deliveryAddress = UIFont(name: "Poppins-Medium", size: 15)
            static let usernameLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let addressLabel = UIFont(name: "Poppins-Light", size: 10)
            static let subtotalLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let subtotalConsLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let taxLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let taxCostLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let deliveryFee = UIFont(name: "Poppins-Medium", size: 12)
            static let deliveryFeeCost = UIFont(name: "Poppins-Medium", size: 12)
            static let totalPriceLabel = UIFont(name: "Poppins-Medium", size: 12)
            static let totalCostLabel = UIFont(name: "Poppins-SemiBold", size: 22)
            static let payNowButton = UIFont(name: "Poppins-SemiBold", size: 14)
        }
    }
}
