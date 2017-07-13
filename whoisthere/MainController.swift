//
//  ViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 05/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import CoreBluetooth
import UIKit

class MainController: UICollectionViewController {
    
    var peripheralManager = CBPeripheralManager()
    var centralManager: CBCentralManager?
    var visiblePeripherals = Array<Peripheral>()
    var cachedPeripherals = Array<Peripheral>()
    var cachedPeripheralNames = Dictionary<String, String>()
    var timer = Timer()
    
    let mainCellReuseIdentifier = "MainCell"
    let columnCount = 2
    
    let WHOS_THERE_SERVICE_UUID = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF5")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileButton()
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        scheduledTimerWithTimeInterval()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateAdvertisingData()
    }
    
    func setupProfileButton () {
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "_profile_title".localized,
            style: .done,
            target: self,
            action: #selector(rightButtonAction)
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func rightButtonAction(sender: UIBarButtonItem) {
        
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func scheduledTimerWithTimeInterval(){
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.clearPeripherals), userInfo: nil, repeats: true)
    }
    
    func clearPeripherals(){
        
        visiblePeripherals = cachedPeripherals
        cachedPeripherals.removeAll()
        collectionView?.reloadData()
    }
    
    func updateAdvertisingData() {
        
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let userData =  UserData()
        let advertisementData = String(format: "%@|%d|%d", userData.name, userData.avatarId, userData.colorId)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[WHOS_THERE_SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    
    
    func addOrUpdatePeripheralList(peripheral: Peripheral, list: inout Array<Peripheral>) {
        
        if !list.contains(where: { $0.item.identifier == peripheral.item.identifier }) {
            
            list.append(peripheral)
            collectionView?.reloadData()
        }
        else if list.contains(where: { $0.item.identifier == peripheral.item.identifier
            && $0.name == "unknown"}) && peripheral.name != "unknown" {
            
            for index in 0..<list.count {
                
                if (list[index].item.identifier == peripheral.item.identifier) {
                    
                    list[index].name = peripheral.name
                    collectionView?.reloadData()
                    break
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource protocol
extension MainController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visiblePeripherals.count
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellReuseIdentifier, for: indexPath as IndexPath) as! MainCell
        
        let peripheral = visiblePeripherals[indexPath.row]
        
        let advertisementData = peripheral.name.components(separatedBy: "|")
        
        
        
        if (advertisementData.count > 1) {
            
            cell.nameLabel?.text = advertisementData[0]
            cell.avatarImageView.image = UIImage(named: String(format: "%@%@", Constants.kAvatarImagePrefix, advertisementData[1]))
            cell.backgroundColor = Constants.colors[Int(advertisementData[2])!]
        }
        else {
            cell.nameLabel?.text = peripheral.name
            cell.avatarImageView.image = UIImage(named: "avatar0")
            cell.backgroundColor = UIColor.gray
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol
extension MainController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let peripheral = visiblePeripherals[indexPath.row]
        AlertHelper.warn(delegate: self, message: peripheral.name)
    }
}

extension MainController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

extension MainController : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            
            self.centralManager?.scanForPeripherals(withServices: [WHOS_THERE_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName = cachedPeripheralNames[peripheral.identifier.description] ?? "unknown"
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
            peripheralName = advertisementName
            cachedPeripheralNames[peripheral.identifier.description] = peripheralName
        }
        
        let peripheral = Peripheral(item: peripheral, name: peripheralName)
        
        self.addOrUpdatePeripheralList(peripheral: peripheral, list: &visiblePeripherals)
        self.addOrUpdatePeripheralList(peripheral: peripheral, list: &cachedPeripherals)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
}

extension MainController : CBPeripheralDelegate {
    
    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics! {
            let characteristic = characteristic as CBCharacteristic
            
            let data = "efe cem kocabas".data(using: .utf8)
            peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
}

extension MainController : CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn){
            
            let transferService = CBMutableService(type: WHOS_THERE_SERVICE_UUID, primary: true)
            peripheralManager.add(transferService)
            
            updateAdvertisingData()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        let dataStr = String(data: requests[0].value!, encoding: String.Encoding.utf8) as String!
        
        AlertHelper.warn(delegate: self, message: dataStr!)
    }
}












