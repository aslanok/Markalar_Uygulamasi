//
//  ViewController.swift
//  Markalar
//
//  Created by MacBook on 18.03.2022.
// prototype dynamic properties içinde row section ile alakalı ayarlamaları yapıyoruz
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    var markalar : [String] = []
    
    var fileURL : URL!
    var sayac : Int = 0
    var selectedRow : Int = -1
    
    var markaAciklamalari : [String] = []
    var markaAciklamasi : String = ""
    
    //viewDidLoad sadece ekran ilk yüklenirken çalışır. Eğer ki sürekli değişen bir ana ekran kurguluyorsak bunu viewWillAppear ile kurgulamalıyız
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
        
        //aşağıdaki satırları da kullanarak bu uygulamadaki title vb özellikleri değiştirebiliriz.
        //self.title = "Markalar -1"
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let editButton = editButtonItem
        editButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = editButton
        
        let baseURL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        //print(baseURL)
        
        fileURL = baseURL.appendingPathComponent("Markalar.txt")
        //print(fileURL!)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //böyle direkt return diyince hiçbişey yapma demiş oluyorz
        if selectedRow == -1 {
            return
        }
        if markaAciklamasi == "" {
            markaAciklamalari.remove(at: selectedRow)
            markalar.remove(at: selectedRow)
        } else if markaAciklamasi == markaAciklamalari[selectedRow] {
            return
        } else {
            markaAciklamalari[selectedRow] = markaAciklamasi
        }
        saveData()
        table.reloadData()
        
    }
    

    @IBAction func btnAddClicked(_ sender: UIBarButtonItem) {
        if table.isEditing == true{
            return
        }
        
        let alert = UIAlertController(title: "Marka Ekle", message: "Eklemek Istediginiz markayi giriniz", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { txtMarkaAdi in
            txtMarkaAdi.placeholder = "Marka Adı"
        })
        
        let actionAdd = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default, handler: { action in
            let firstTextField = alert.textFields![0] as UITextField
            self.markaEkle(markaAdi: firstTextField.text!)
        })
        
        let actionCancel = UIAlertAction(title: "İptal", style: .default, handler: nil)
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markalar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : UITableViewCell = UITableViewCell()
        let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
        
        
        cell.textLabel?.text = markalar[indexPath.row]
        //oluşturduğumuz her hücre için xCode bir textLabel oluşturuyor
        return cell
    }
    
    func markaEkle(markaAdi : String){
        //let markaAdi : String = "\(sayac). Yeni Marka"
        sayac = sayac + 1
        //markalar.append(markaAdi)
        //let indexPath : IndexPath = IndexPath(row: markalar.count - 1 , section: 0)
        
        //tabloya baştan ekleme yapmak
        markalar.insert(markaAdi, at: 0)
        markaAciklamalari.insert("Girilmedi", at: 0)
        
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        
        
        //tabloya ekleme
        table.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
        saveData()
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        performSegue(withIdentifier: "goAciklamalar", sender: self)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated) //bu satır sayesinde edit moduna geçecek
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            markalar.remove(at: indexPath.row)
            markaAciklamalari.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            saveData()
            
        }
    }
    
    
    //user defaults ufak çaplı verileri kaydetmek için son derece uygundur
    func saveData(){
        UserDefaults.standard.set(markalar, forKey: "markalar")
        UserDefaults.standard.set(markaAciklamalari, forKey: "aciklamalar") //forkey'deki anahtarı load ile yüklerken kullanacağız
        
        /*
        let veriler = NSArray(array: markalar)
        
        do {
            try veriler.write(to: fileURL)
        } catch{
            print("Dosyaya yazarken hata oluştu")
        }
        */
    }
    
    func loadData(){
        if let loadedData : [String] = UserDefaults.standard.value(forKey: "markalar") as? [String] {
        //if let loadedData : [String] = NSArray(contentsOf: fileURL) as? [String] {
            markalar = loadedData
        }
        if let aciklamalar : [String] = UserDefaults.standard.value(forKey: "aciklamalar") as? [String] {
            markaAciklamalari = aciklamalar
        }
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seçilen marka : \(markalar[indexPath.row])")
        performSegue(withIdentifier: "goAciklamalar", sender: self)
    }
    
    //segue geçiş yapmadan önceki hazırlıkları
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let aciklamaVC : AciklamalarViewController = segue.destination as! AciklamalarViewController
        selectedRow = table.indexPathForSelectedRow!.row
        aciklamaVC.setAciklama(a: "\(markaAciklamalari[selectedRow])")
        aciklamaVC.masterVC = self
        
        
    }
    
    
}

