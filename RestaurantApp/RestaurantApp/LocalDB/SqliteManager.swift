//
//  SqliteManager.swift
//  RestaurantApp
//
//  Created by iMac on 05/05/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation
import SQLite

class SqlManager {
    
    static let instance = SqlManager()
    private var db: Connection? = nil
    private let restaurant = Table("restaurant")
    private let id = Expression<Int>("id")
    private let name = Expression<String?>("name")
    private let phone = Expression<String>("phone")
    private let address = Expression<String>("address")
    private let reserve_url = Expression<String>("reserve_url")
    private let image_url = Expression<String>("image_url")
    
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!

        do {
            db = try Connection("\(path)/SqlManager.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }

        createTable()
    }

    func createTable() {
        do {
            try db!.run(restaurant.create(ifNotExists: true) { table in
            table.column(id,unique: true)
            table.column(name)
            table.column(phone)
            table.column(address)
                table.column(reserve_url)
                table.column(image_url)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addRestaurant(cid: Int,cname: String, cphone: String, caddress: String,creserve_url: String, cimage_url: String) -> Int64? {
        do {
            let insert = restaurant.insert(id <- cid, name <- cname, phone <- cphone, address <- caddress,reserve_url <- creserve_url, image_url <- cimage_url)
            let id = try db!.run(insert)
            print("Inserted")

            return id
        } catch let error{
            print("Insert failed", error)
            return -1
        }
    }
    
    func getRestaurant() -> [Restaurants] {
        var rests = [Restaurants]()

        do {
            for rest in try db!.prepare(self.restaurant) {
                rests.append(Restaurants(
                    id: Int(rest[id]),
                name: rest[name]!,
                phone: rest[phone],
                address: rest[address],
                reserve_url: rest[reserve_url],
                image_url: rest[image_url]
                ))
            }
        } catch {
            print("Select failed")
        }

        return rests
    }
}
