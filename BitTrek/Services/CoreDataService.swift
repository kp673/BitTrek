//
//  CoreDataService.swift
//  BitTrek
//
//  Created by Kush Patel on 3/22/25.
//

import CoreData
import Foundation

class PortfolioDataService {

    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    private(set) var savedEntity: [PortfolioEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading Core Data! ", error)
            }
        }
        self.getPortfolio()
    }

    // MARK: - Public

    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntity.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }

    //MARK: - Private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)

        do {
            savedEntity = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Portfolio Entity")
        }
    }

    private func add(coin: Coin, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }

    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()

    }

    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error Saving to Core data! ", error)
        }
    }

    private func applyChanges() {
        save()
        getPortfolio()
    }

}
