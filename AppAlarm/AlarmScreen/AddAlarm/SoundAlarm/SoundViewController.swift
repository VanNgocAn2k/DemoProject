//
//  SoundViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 04/10/2022.
//

import UIKit
import AVFoundation

protocol PassSoundAlarmDelegate: AnyObject {
    func updateSuond(sound: String)
}

class SoundViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var player: AVAudioPlayer?
    var showImageIndex: Int = 0
    weak var delegate: PassSoundAlarmDelegate?
    
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
        tableView.register(UINib(nibName: "SoundTableViewCell", bundle: nil), forCellReuseIdentifier: "SoundTableViewCell")
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        
        let ring = self.arrRing[showImageIndex]
        delegate?.updateSuond(sound: ring)
    }
    
}
extension SoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRing.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundTableViewCell", for: indexPath) as! SoundTableViewCell
        
        cell.soundLabel?.text = self.arrRing[indexPath.row]
        // ẩn hiện image khi ấn vào nỗi row
        if showImageIndex == indexPath.row{
            cell.checkmarkImage.isHidden = false
        }else{
            cell.checkmarkImage.isHidden = true
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
