//
//  RingViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 30/09/2022.
//

import UIKit
import AVFoundation

protocol PassSoundDelegate: AnyObject {
    func updateSuond(sound: String)
}

class RingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var player: AVAudioPlayer?
    var showImageIndex: Int = 0
    
    weak var delegate: PassSoundDelegate?
    
    var arrRing: [String] = ["Conmuabanggia", "Comoinoicu", "Demtrangtinhyeu", "Matmoc", "Viyeucudamdau", "Banbietgichua", "Wolvesnaruto", "Nokia8250", "Saohayradequa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
    }
    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .gray
        // ẩn những row chống
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ShowImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowImageTableViewCell")
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveRingAction(_ sender: Any) {
        dismiss(animated: true)
        let ring = self.arrRing[showImageIndex]
        delegate?.updateSuond(sound: ring)
        print(ring)
    }
    
    
}
extension RingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRing.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowImageTableViewCell", for: indexPath) as! ShowImageTableViewCell
        
        cell.detailLabel?.text = self.arrRing[indexPath.row]
        // ẩn hiện image khi ấn vào nỗi row
        if showImageIndex == indexPath.row{
            cell.showImage.isHidden = false
        }else{
            cell.showImage.isHidden = true
        }
        
        return cell
        
    }
    // chọn vào row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Bỏ màu của dòng chọn
        tableView.deselectRow(at: indexPath, animated: true)
        
        // ấn vào mỗi row sẽ phát nhạc
        do {
            self.player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(arrRing[indexPath.row])", ofType: "mp3")!))
            self.player?.prepareToPlay()
        }
        catch {
            print(error)
        }
        self.player?.play()
        //
        showImageIndex = indexPath.row
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
