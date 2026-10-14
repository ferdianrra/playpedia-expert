//
//  CoreDataFavoriteRepository.swift
//  Playpedia
//
//  Created by Ferdiansyah Annora on 12/10/26.
//

import Foundation
import CoreData
import Combine

final class CoreDataFavoriteRepository: FavoriteRepository {
    private let container: NSPersistentContainer
    private let changes = PassthroughSubject<Void, Never>()
    private var storeError: Error?
    private let legacyDefaults: UserDefaults?

    init(inMemory: Bool = false, legacyDefaults: UserDefaults? = nil) {
        self.legacyDefaults = legacyDefaults
        let entity = NSEntityDescription()
        entity.name = "FavoriteRecord"
        entity.managedObjectClassName = "NSManagedObject"
        entity.properties = [("id", NSAttributeType.integer64AttributeType),
                             ("payload", .binaryDataAttributeType), ("savedAt", .dateAttributeType)].map {
            let attribute = NSAttributeDescription()
            attribute.name = $0.0
            attribute.attributeType = $0.1
            attribute.isOptional = false
            return attribute
        }
        entity.uniquenessConstraints = [["id"]]
        let model = NSManagedObjectModel()
        model.entities = [entity]
        container = NSPersistentContainer(name: "PlaypediaFavorites", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = inMemory ? NSInMemoryStoreType : NSSQLiteStoreType
        if !inMemory {
            description.url = NSPersistentContainer.defaultDirectoryURL()
                .appendingPathComponent("PlaypediaFavorites.sqlite")
        }
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { [weak self] _, error in self?.storeError = error }
    }

    func observeGames() -> AnyPublisher<[Game], Error> {
        changes.prepend(())
            .flatMap { [self] in readGames() }
            .eraseToAnyPublisher()
    }

    func toggle(_ game: Game) -> AnyPublisher<Void, Error> {
        perform { [self] context in
            try migrateLegacyFavorites(context)
            let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteRecord")
            request.predicate = NSPredicate(format: "id == %lld", Int64(game.id))
            if let record = try context.fetch(request).first {
                context.delete(record)
            } else {
                try insert(GameDTO(game: game), into: context)
            }
            try context.save()
        }
        .handleEvents(receiveOutput: { [weak self] in self?.changes.send(()) })
        .eraseToAnyPublisher()
    }

    private func readGames() -> AnyPublisher<[Game], Error> {
        perform { [self] context in
            try migrateLegacyFavorites(context)
            let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteRecord")
            request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
            return try context.fetch(request).map { record in
                guard let data = record.value(forKey: "payload") as? Data else {
                    throw CocoaError(.coderReadCorrupt)
                }
                return try JSONDecoder().decode(GameDTO.self, from: data).domain
            }
        }
    }

    private func insert(_ game: GameDTO, into context: NSManagedObjectContext) throws {
        let record = NSEntityDescription.insertNewObject(forEntityName: "FavoriteRecord", into: context)
        record.setValue(Int64(game.id), forKey: "id")
        record.setValue(try JSONEncoder().encode(game), forKey: "payload")
        record.setValue(Date(), forKey: "savedAt")
    }

    private func migrateLegacyFavorites(_ context: NSManagedObjectContext) throws {
        guard let data = legacyDefaults?.data(forKey: "favoriteGames") else { return }
        let games = try JSONDecoder().decode([GameDTO].self, from: data)
        for game in games.reversed() {
            let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteRecord")
            request.predicate = NSPredicate(format: "id == %lld", Int64(game.id))
            if try context.count(for: request) == 0 { try insert(game, into: context) }
        }
        try context.save()
        legacyDefaults?.removeObject(forKey: "favoriteGames")
    }

    private func perform<Value>(
        _ operation: @escaping (NSManagedObjectContext) throws -> Value
    ) -> AnyPublisher<Value, Error> {
        Deferred { [self] in
            Future { promise in
                if let storeError = self.storeError { promise(.failure(storeError)); return }
                let context = self.container.viewContext
                context.perform {
                    do { promise(.success(try operation(context))) } catch {
                        context.rollback()
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
