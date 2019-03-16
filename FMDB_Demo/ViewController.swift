//
//  ViewController.swift
//  FMDB_Demo
//
//  Created by Marta Bella on 16/03/2019.
//  Copyright © 2019 CFGS La Salle Gracia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataBasePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager()
        if let dirDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let databaseURL = dirDocument.appendingPathComponent("users.db")
            dataBasePath = databaseURL.path
            
            let userDB = FMDatabase(path:dataBasePath)
            
            if userDB.open(){
                print("BBDD abierta")
                if !userDB.executeStatements("CREATE TABLE IF NOT EXISTS USERS (USERNAME TEXT PRIMARY KEY, EMAIL TEXT NOT NULL)"){
                    print(userDB.lastError().localizedDescription)
                }else{
                    print("Creada Tabla USERS")
                    print("Insertando un registro...")
                    let insertSQL = "INSERT INTO USERS (USERNAME, EMAIL) VALUES (?, ?)"
                    let data = ["mbella","mbella@lasalle.cat"]
                    userDB.executeUpdate(insertSQL, withArgumentsIn: data)
                    
                    print("Consultando registros ....")
                    let selectSQL = "SELECT * FROM USERS"
                    let dataSelect = [Any]()
                    if let resultSet = userDB.executeQuery(selectSQL, withArgumentsIn: dataSelect){
                        
                        while (resultSet.next()){
                            print(resultSet.string(forColumnIndex: 0))
                            print(resultSet.string(forColumnIndex: 1))
                        }
                        resultSet.close()
                    }
                
                }
                
                userDB.close()
                print("BBDD cerrada")
            }else{
                print(userDB.lastError().localizedDescription)
            }
        }
    }


}

