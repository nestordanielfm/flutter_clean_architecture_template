import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('should create user with all properties', () {
      const user = User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        token: 'test_token',
        firstName: 'Test',
        lastName: 'User',
      );

      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.token, 'test_token');
      expect(user.firstName, 'Test');
      expect(user.lastName, 'User');
    });

    test('should create user with nullable properties as null', () {
      const user = User(id: 1, username: 'testuser', email: 'test@example.com');

      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.token, isNull);
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
    });

    test('should have correct props for equality', () {
      const user = User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        token: 'test_token',
        firstName: 'Test',
        lastName: 'User',
      );

      expect(user.props, [
        1,
        'testuser',
        'test@example.com',
        'test_token',
        'Test',
        'User',
      ]);
    });

    test('users with same properties should be equal', () {
      const user1 = User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
      );
      const user2 = User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
      );

      expect(user1, user2);
    });

    test('users with different properties should not be equal', () {
      const user1 = User(
        id: 1,
        username: 'testuser1',
        email: 'test1@example.com',
      );
      const user2 = User(
        id: 2,
        username: 'testuser2',
        email: 'test2@example.com',
      );

      expect(user1, isNot(user2));
    });
  });
}
