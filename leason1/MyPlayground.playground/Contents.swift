import UIKit

var str = "Hello, playground"

var input =
    [
        "ITEM000001",
        "ITEM000001",
        "ITEM000001",
        "ITEM000001",
        "ITEM000001",
        "ITEM000003-2",
        "ITEM000005",
        "ITEM000005",
        "ITEM000005"
]


struct Item {
    var barcode: String = ""
    var name: String = ""
    var unit: String = ""
    var price: Double = 0.0
}

struct PromotionItem {
    var type: String = ""
    var barcodes: Array<String> = [""]
}

struct ReceiptItem{
    var name: String = ""
    var number: Int = 0
    var price: Double = 0.0
    var total: Double = 0.0
    var unit: String = ""
    var discount: Double = 0.0
}

struct InputItem {
    var barcode: String = ""
    var number: Int = 0
}
func loadAllItems() -> Array<Item> {
    return [
        Item(barcode:"ITEM000000", name:"可口可乐", unit: "瓶", price:3.00),
        Item(barcode:"ITEM000001", name:"雪碧", unit: "瓶", price:3.00),
        Item(barcode:"ITEM000002", name:"苹果", unit: "斤", price:5.50),
        Item(barcode:"ITEM000003", name:"荔枝", unit: "斤", price:15.00),
        Item(barcode:"ITEM000004", name:"电池", unit: "个", price:2.00),
        Item(barcode:"ITEM000005", name:"方便面", unit: "袋", price:4.50),
        Item(barcode:"ITEM000001", name:"雪碧", unit: "瓶", price:3.00),
        Item(barcode:"ITEM000001", name:"雪碧", unit: "瓶", price:3.00),
        Item(barcode:"ITEM000001", name:"雪碧", unit: "瓶", price:3.00),
       Item(barcode:"ITEM000001", name:"雪碧", unit: "瓶", price:3.00),
    ];
}

func loadPromotions() -> Array<PromotionItem>{
    return [
        PromotionItem(type: "BUY_TWO_GET_ONE_FREE", barcodes: ["ITEM000000",
                                                              "ITEM000001",
                                                              "ITEM000005"]),
        PromotionItem(type: "OTHER_PROMOTION", barcodes: ["ITEM000003",
                                                         "ITEM000004"])
    ];
}

func getPromotions(barcode: String) -> [PromotionItem]{
    let allPromotions = loadPromotions()
    return allPromotions.filter { (promotionItem) -> Bool in
        promotionItem.barcodes.contains(barcode)
    }
}

func calculateWithDiscount(promotions: Array<PromotionItem>, item: InputItem) -> ReceiptItem {
    let totalPrice =  promotions.map { (promotionItem) -> ReceiptItem in
        let itemInfoInStore = (loadAllItems().filter { (itemInStore) -> Bool in
            itemInStore.barcode == item.barcode
        })[0]
        switch promotionItem.type {
        case "BUY_TWO_GET_ONE_FREE":
            let acutallNumber = Double(item.number - item.number / 3)
   
            return ReceiptItem(name: itemInfoInStore.name,
                               number: item.number,
                               price: itemInfoInStore.price,
                               total: acutallNumber*itemInfoInStore.price,
                               unit: itemInfoInStore.unit,
                               discount: Double(item.number / 3) * itemInfoInStore.price)
            
    
        default:
            return ReceiptItem(name: itemInfoInStore.name,
                               number: item.number,
                               price: itemInfoInStore.price,
                               total: Double(item.number)*itemInfoInStore.price,
                               unit: itemInfoInStore.unit,
                               discount: 0.0)
        }
    }
    return totalPrice[0]
}

func calculateWithoutDiscount(item: InputItem) -> ReceiptItem {
    let itemInfoInStore = (loadAllItems().filter { (itemInStore) -> Bool in
        itemInStore.barcode == item.barcode
    })[0]
    return ReceiptItem(name: itemInfoInStore.name,
                       number: item.number,
                       price: itemInfoInStore.price,
                       total: Double(item.number)*itemInfoInStore.price,
                       unit: itemInfoInStore.unit,
                       discount: 0.0)
}

func formatInput(inputs: [String]) -> Array<InputItem> {
    return inputs.map({ (input) -> InputItem in
        let inputArray = input.components(separatedBy: "-")
        let number: Int = inputArray.count > 1 ? (inputArray[1] as NSString).integerValue : 1
        return InputItem(barcode: inputArray[0], number: number)
    })
}

func formatOutput(shoppingList: [ReceiptItem]) -> ([String], Double, Double) {
    var discount = 0.0
    var total = 0.0
    let formattedItemInfor =  shoppingList.map { (receiptItem) -> String in
        discount += receiptItem.discount
        total += receiptItem.total
        return "名称: " + receiptItem.name +
            " , 数量: " + String(receiptItem.number) + receiptItem.unit +
            " , 单价: " + String(receiptItem.price) +
            "(元) , 小计: " + String(receiptItem.total) +
        "(元) \r"
    }
    
    return (formattedItemInfor, total, discount)
}

func printResult(shoppingResults: ([String], Double, Double)) {
    print("***<没钱赚商店>收据***")
    shoppingResults.0.map { (shoppingInfo) -> Void in
        print(shoppingInfo)
    }
    print("----------------------")
    print("总计：" + String(shoppingResults.1) + "(元)")
    print("节省：" + String(shoppingResults.2) + "(元)")
    print("**********************")
}

func printReceipt(inputs: [String]) -> String {
    let formatInputs = formatInput(inputs: input)
    let shoppingList = formatInputs.map { (item) -> ReceiptItem in
        let promotions = getPromotions(barcode: item.barcode)
        if (promotions.count > 0) {
            return calculateWithDiscount(promotions: promotions, item: item)
        } else {
            return calculateWithoutDiscount(item: item)
        }
    }
    print("haha")
    printResult(shoppingResults: formatOutput(shoppingList: shoppingList))
    return "printReceipt"
}

printReceipt(inputs: input)
