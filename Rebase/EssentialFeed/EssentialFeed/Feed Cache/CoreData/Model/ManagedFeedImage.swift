//
// Copyright © Essential Developer. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
final class ManagedFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
	
	func toLocal() -> LocalFeedImage {
		return LocalFeedImage(
			id: id,
			description: imageDescription,
			location: location,
			url: url
		)
	}
}

extension Array where Element == ManagedFeedImage {
	func toLocal() -> [LocalFeedImage] {
		return map { LocalFeedImage(
			id: $0.id,
			description: $0.imageDescription,
			location: $0.location,
			url: $0.url
		)
		}
	}
}
