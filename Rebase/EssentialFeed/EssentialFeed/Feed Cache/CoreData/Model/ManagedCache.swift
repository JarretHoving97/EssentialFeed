//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedCache)
final class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
	func localFeed() -> [LocalFeedImage] {
		return feed.compactMap { $0 as? ManagedFeedImage }.toLocal()
	}

	static func insert(_ feed: [LocalFeedImage], timestamp: Date, with context: NSManagedObjectContext) throws {
		let newCache = try ManagedCache.createNewCache(in: context)

		let managedFeed = NSOrderedSet(array: feed.map { local in
			let managed = ManagedFeedImage(context: context)
			managed.id = local.id
			managed.imageDescription = local.description
			managed.location = local.location
			managed.url = local.url
			return managed
		})

		newCache.timestamp = timestamp
		newCache.feed = managedFeed

		try context.save()
	}

	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let fetchRequest = NSFetchRequest<ManagedCache>(entityName: Self.entity().name!)
		return try context.fetch(fetchRequest).first
	}

	private static func createNewCache(in context: NSManagedObjectContext) throws -> ManagedCache {
		try find(in: context).map(context.delete)
		return ManagedCache(context: context)
	}

	static func deleteCache(in context: NSManagedObjectContext) throws {
		try find(in: context).map(context.delete).map(context.save)
	}
}
