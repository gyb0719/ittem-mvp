import 'package:flutter_test/flutter_test.dart';
import 'package:ittem_mvp/shared/models/item_model.dart';

void main() {
  group('ItemModel.fromJson', () {
    test('defaults rating and reviewCount when missing', () {
      final json = {
        'id': '1',
        'title': 'Item',
        'description': 'Desc',
        'price': 100,
        'imageUrl': 'http://example.com',
        'category': 'cat',
        'location': 'loc',
        'createdAt': DateTime(2020).toIso8601String(),
      };

      final item = ItemModel.fromJson(json);

      expect(item.rating, 0.0);
      expect(item.reviewCount, 0);
    });
  });
}
