//
//  ViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 05/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import CoreBluetooth
import UIKit

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    let reuseIdentifier = "MainCell"
    let columnCount = 2
    let margin : CGFloat = 10
    var visibleDevices = Array<Device>()
    var cachedDevices = Array<Device>()
    var cachedPNames = Dictionary<String, String>()
    var timer = Timer()
    var selectedPeripheral : CBPeripheral?
    
    
    var pManager = CBPeripheralManager()
    var centralManager: CBCentralManager? 
    
    var receiveQueue = [NSData]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "_profile_title".localized,
            style: .done,
            target: self,
            action: #selector(rightButtonAction)
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        pManager = CBPeripheralManager(delegate: self, queue: nil)
        
        scheduledTimerWithTimeInterval()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateAdvertisingData()
    }
    
    func rightButtonAction(sender: UIBarButtonItem) {
        
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    
    
    func scheduledTimerWithTimeInterval(){
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.clearPeripherals), userInfo: nil, repeats: true)
    }
    
    func clearPeripherals(){
        
        visibleDevices = cachedDevices
        cachedDevices.removeAll()
        collectionView?.reloadData()
    }
    
    func updateAdvertisingData() {
        
        if (pManager.isAdvertising) {
            pManager.stopAdvertising()
        }
        
        let defaults = UserDefaults.standard
        let avatarId = defaults.integer(forKey: UserDataKeys.avatarId)
        let colorId = defaults.integer(forKey: UserDataKeys.colorId)
        let name = defaults.string(forKey: UserDataKeys.name) ?? ""
        
        let advertisementData = String(format: "%@|%d|%d", name, avatarId, colorId)
        
        pManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[BLEConstants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn){
            
            updateAdvertisingData()
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            
            self.centralManager?.scanForPeripherals(withServices: [BLEConstants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
        else {
            // do something like alert the user that ble is not on
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName = cachedPNames[peripheral.identifier.description] ?? "unknown"
        
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
            peripheralName = advertisementName
            cachedPNames[peripheral.identifier.description] = peripheralName
        }
        
        let device = Device(peripheral: peripheral, name: peripheralName)
        
        self.addOrUpdatePeripheralList(device: device, list: &visibleDevices)
        self.addOrUpdatePeripheralList(device: device, list: &cachedDevices)
    }
    
    func addOrUpdatePeripheralList(device: Device, list: inout Array<Device>) {

        if !list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            
            list.append(device)
            collectionView?.reloadData()
        }
        else if list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier
            && $0.name == "unknown"}) && device.name != "unknown" {
            
            for index in 0..<list.count {
                
                if (list[index].peripheral.identifier == device.peripheral.identifier) {
                    
                    list[index].name = device.name
                    collectionView?.reloadData()
                    break
                }
            }
            
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleDevices.count
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MainCell
        
        let device = visibleDevices[indexPath.row]
        
        let advertisementData = device.name.components(separatedBy: "|")
        
        if (advertisementData.count > 1) {
            
            cell.nameLabel?.text = advertisementData[0]
            cell.avatarImageView.image = UIImage(named: String(format: "avatar%@", advertisementData[1]))
            cell.backgroundColor = ColorList.colors[Int(advertisementData[2])!]
        }
        else {
            cell.nameLabel?.text = device.name
            cell.avatarImageView.image = UIImage(named: "avatar0")
            cell.backgroundColor = UIColor.gray
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let chatViewController = ChatViewController()
        chatViewController.deviceUUID = visibleDevices[indexPath.row].peripheral.identifier
        chatViewController.deviceAttributes = visibleDevices[indexPath.row].name
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
}










