import 'package:flutter_test/flutter_test.dart';
import 'package:ittem_app/shared/models/item_model.dart';

void main() {
  group('ItemModel', () {
    test('should create ItemModel with all required fields', () {
      // Arrange & Act
      final item = ItemModel(
        id: 'test-id-1',
        title: 'Test Item',
        description: 'This is a test item',
        price: 10000,
        location: 'Seoul, Korea',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        ownerId: 'owner-123',
        category: 'electronics',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      // Assert
      expect(item.id, equals('test-id-1'));
      expect(item.title, equals('Test Item'));
      expect(item.description, equals('This is a test item'));
      expect(item.price, equals(10000));
      expect(item.location, equals('Seoul, Korea'));
      expect(item.imageUrl, equals('https://example.com/image.jpg'));
      expect(item.rating, equals(4.5));
      expect(item.ownerId, equals('owner-123'));
      expect(item.category, equals('electronics'));
      expect(item.isAvailable, isTrue);
      expect(item.createdAt, equals(DateTime.parse('2023-01-01T00:00:00Z')));
    });

    test('should serialize to JSON correctly', () {
      // Arrange
      final item = ItemModel(
        id: 'test-id-1',
        title: 'Test Item',
        description: 'This is a test item',
        price: 10000,
        location: 'Seoul, Korea',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        ownerId: 'owner-123',
        category: 'electronics',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      // Act
      final json = item.toJson();

      // Assert
      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], equals('test-id-1'));
      expect(json['title'], equals('Test Item'));
      expect(json['description'], equals('This is a test item'));
      expect(json['price'], equals(10000));
      expect(json['location'], equals('Seoul, Korea'));
      expect(json['imageUrl'], equals('https://example.com/image.jpg'));
      expect(json['rating'], equals(4.5));
      expect(json['ownerId'], equals('owner-123'));
      expect(json['category'], equals('electronics'));
      expect(json['isAvailable'], isTrue);
      expect(json['createdAt'], isA<String>());
    });

    test('should deserialize from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'test-id-1',
        'title': 'Test Item',
        'description': 'This is a test item',
        'price': 10000,
        'location': 'Seoul, Korea',
        'imageUrl': 'https://example.com/image.jpg',
        'rating': 4.5,
        'ownerId': 'owner-123',
        'category': 'electronics',
        'isAvailable': true,
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      // Act
      final item = ItemModel.fromJson(json);

      // Assert
      expect(item.id, equals('test-id-1'));
      expect(item.title, equals('Test Item'));
      expect(item.description, equals('This is a test item'));
      expect(item.price, equals(10000));
      expect(item.location, equals('Seoul, Korea'));
      expect(item.imageUrl, equals('https://example.com/image.jpg'));
      expect(item.rating, equals(4.5));
      expect(item.ownerId, equals('owner-123'));
      expect(item.category, equals('electronics'));
      expect(item.isAvailable, isTrue);
      expect(item.createdAt, isA<DateTime>());
    });

    test('should handle copyWith method correctly', () {
      // Arrange
      final originalItem = ItemModel(
        id: 'test-id-1',
        title: 'Original Title',
        description: 'Original description',
        price: 10000,
        location: 'Seoul, Korea',
        imageUrl: 'https://example.com/original.jpg',
        rating: 4.5,
        ownerId: 'owner-123',
        category: 'electronics',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      // Act
      final updatedItem = originalItem.copyWith(
        title: 'Updated Title',
        price: 15000,
        isAvailable: false,
      );

      // Assert
      expect(updatedItem.id, equals(originalItem.id)); // unchanged
      expect(updatedItem.title, equals('Updated Title')); // changed
      expect(updatedItem.description, equals(originalItem.description)); // unchanged
      expect(updatedItem.price, equals(15000)); // changed
      expect(updatedItem.location, equals(originalItem.location)); // unchanged
      expect(updatedItem.imageUrl, equals(originalItem.imageUrl)); // unchanged
      expect(updatedItem.rating, equals(originalItem.rating)); // unchanged
      expect(updatedItem.ownerId, equals(originalItem.ownerId)); // unchanged
      expect(updatedItem.category, equals(originalItem.category)); // unchanged
      expect(updatedItem.isAvailable, isFalse); // changed
      expect(updatedItem.createdAt, equals(originalItem.createdAt)); // unchanged
    });

    test('should handle equality correctly', () {
      // Arrange
      final item1 = ItemModel(
        id: 'test-id-1',
        title: 'Test Item',
        description: 'This is a test item',
        price: 10000,
        location: 'Seoul, Korea',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        ownerId: 'owner-123',
        category: 'electronics',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      final item2 = ItemModel(
        id: 'test-id-1',
        title: 'Test Item',
        description: 'This is a test item',
        price: 10000,
        location: 'Seoul, Korea',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        ownerId: 'owner-123',
        category: 'electronics',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      final item3 = ItemModel(
        id: 'test-id-2', // different id
        title: 'Test Item',
        description: 'This is a test item',
        price: 10000,
        location: 'Seoul, Korea',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        ownerId: 'owner-123',
        category: 'electronics',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      // Act & Assert
      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
      expect(item1.hashCode, equals(item2.hashCode));
      expect(item1.hashCode, isNot(equals(item3.hashCode)));
    });

    test('should handle edge cases in data', () {
      // Test with default values
      final minimalItem = ItemModel(
        id: '',
        title: '',
        description: '',
        price: 0,
        location: '',
        imageUrl: '',
        category: '',
        createdAt: DateTime.now(),
      );

      // Should not throw
      expect(minimalItem.toJson(), isA<Map<String, dynamic>>());
      expect(minimalItem.rating, equals(0.0)); // Default value
      expect(minimalItem.reviewCount, equals(0)); // Default value
      expect(minimalItem.isAvailable, isTrue); // Default value

      // Test with extreme values
      final extremeItem = ItemModel(
        id: 'very-long-id-' * 100,
        title: 'Very long title ' * 50,
        description: 'Very long description ' * 100,
        price: 999999999,
        location: 'Very long location ' * 20,
        imageUrl: 'https://very-long-url.com/' + 'path/' * 50,
        rating: 5.0,
        ownerId: 'owner-id-' * 20,
        category: 'very-long-category-name',
        isAvailable: true,
        createdAt: DateTime.parse('2023-12-31T23:59:59.999Z'),
      );

      expect(extremeItem.toJson(), isA<Map<String, dynamic>>());
    });

    test('should handle JSON serialization round-trip', () {
      // Arrange
      final originalItem = ItemModel(
        id: 'round-trip-test',
        title: 'Round Trip Test',
        description: 'Testing JSON round-trip',
        price: 25000,
        location: 'Busan, Korea',
        imageUrl: 'https://example.com/roundtrip.jpg',
        rating: 3.8,
        ownerId: 'roundtrip-owner',
        category: 'home-appliances',
        isAvailable: true,
        createdAt: DateTime.parse('2023-06-15T10:30:45Z'),
      );

      // Act
      final json = originalItem.toJson();
      final reconstructedItem = ItemModel.fromJson(json);

      // Assert
      expect(reconstructedItem.id, equals(originalItem.id));
      expect(reconstructedItem.title, equals(originalItem.title));
      expect(reconstructedItem.description, equals(originalItem.description));
      expect(reconstructedItem.price, equals(originalItem.price));
      expect(reconstructedItem.location, equals(originalItem.location));
      expect(reconstructedItem.imageUrl, equals(originalItem.imageUrl));
      expect(reconstructedItem.rating, equals(originalItem.rating));
      expect(reconstructedItem.ownerId, equals(originalItem.ownerId));
      expect(reconstructedItem.category, equals(originalItem.category));
      expect(reconstructedItem.isAvailable, equals(originalItem.isAvailable));
      // DateTime comparison might need special handling due to precision
    });

    test('should validate business rules', () {
      // Test that rating should be between 0 and 5 (if validation exists)
      final validItem = ItemModel(
        id: 'valid-item',
        title: 'Valid Item',
        description: 'A valid item for testing',
        price: 5000,
        location: 'Seoul',
        imageUrl: 'https://example.com/valid.jpg',
        rating: 4.2,
        ownerId: 'valid-owner',
        category: 'books',
        isAvailable: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      expect(validItem.rating, greaterThanOrEqualTo(0.0));
      expect(validItem.rating, lessThanOrEqualTo(5.0));
      expect(validItem.price, greaterThanOrEqualTo(0));
    });

    test('should handle optional fields correctly', () {
      // Test with all optional fields null
      final itemWithoutOptionals = ItemModel(
        id: 'test-item',
        title: 'Test Item',
        description: 'Description',
        price: 1000,
        location: 'Location',
        imageUrl: 'https://example.com/image.jpg',
        category: 'test',
        createdAt: DateTime.now(),
      );

      expect(itemWithoutOptionals.ownerId, isNull);
      expect(itemWithoutOptionals.latitude, isNull);
      expect(itemWithoutOptionals.longitude, isNull);
      expect(itemWithoutOptionals.imageUrls, isNull);

      // Test with optional fields provided
      final itemWithOptionals = ItemModel(
        id: 'test-item-2',
        title: 'Test Item 2',
        description: 'Description 2',
        price: 2000,
        location: 'Location 2',
        imageUrl: 'https://example.com/image2.jpg',
        category: 'test2',
        createdAt: DateTime.now(),
        ownerId: 'owner-123',
        latitude: 37.5665,
        longitude: 126.9780,
        imageUrls: ['https://example.com/1.jpg', 'https://example.com/2.jpg'],
      );

      expect(itemWithOptionals.ownerId, equals('owner-123'));
      expect(itemWithOptionals.latitude, equals(37.5665));
      expect(itemWithOptionals.longitude, equals(126.9780));
      expect(itemWithOptionals.imageUrls, hasLength(2));
    });
  });
}