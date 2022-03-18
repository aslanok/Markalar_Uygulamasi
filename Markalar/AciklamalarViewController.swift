//
//  AciklamalarViewController.swift
//  Markalar
//
//  Created by MacBook on 18.03.2022.
//

import UIKit

class AciklamalarViewController: UIViewController {

    @IBOutlet weak var lblMarkaAciklama: UITextView!
    var aciklama: String = ""
    var masterVC : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblMarkaAciklama.text = aciklama
    }
    
    
    // bu setAciklama fonksiyonunu direkt çağırırsak eğer biz şöyle bir sıkıntımız var oluyor. Açıklamayı girdiğimiz lblMarkaAciklama labeli viewDidLoad'dan sonra geliyor. Ama biz bunu gidip isViewLoaded içine koyarsak ekran yüklendikten sonrakine atıyoruz ve sağlıklı bir şekilde çalışıyor
    func setAciklama(a : String){
        aciklama = a
        if isViewLoaded {
            lblMarkaAciklama.text = aciklama
        }
    }
    
    //bulunduğumuz ekran yok olurken bu satırdaki kodlar çalışacak
    override func viewWillDisappear(_ animated: Bool) {
        masterVC?.markaAciklamasi = lblMarkaAciklama.text
        lblMarkaAciklama.resignFirstResponder() //sayfa yok olurken firstResponder olmaktan çıkıyor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblMarkaAciklama.becomeFirstResponder() //sayfa görünürken firstResponder oluyor
    }
    
    
}
