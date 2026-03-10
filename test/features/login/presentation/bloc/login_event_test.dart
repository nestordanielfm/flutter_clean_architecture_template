import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/features/login/presentation/bloc/login_event.dart';

void main() {
  group('LoginEvent', () {
    test('LoginSubmitted should have username and password', () {
      const event = LoginSubmitted(username: 'testuser', password: 'password');

      expect(event.username, 'testuser');
      expect(event.password, 'password');
      expect(event.props, ['testuser', 'password']);
    });

    test('LoginSubmitted with same values should be equal', () {
      const event1 = LoginSubmitted(username: 'test', password: 'pass');
      const event2 = LoginSubmitted(username: 'test', password: 'pass');

      expect(event1, event2);
    });

    test('LoginSubmitted with different values should not be equal', () {
      const event1 = LoginSubmitted(username: 'test1', password: 'pass1');
      const event2 = LoginSubmitted(username: 'test2', password: 'pass2');

      expect(event1, isNot(event2));
    });

    test('LoginReset should have empty props', () {
      const event = LoginReset();

      expect(event.props, <Object?>[]);
    });

    test('LoginReset instances should be equal', () {
      const event1 = LoginReset();
      const event2 = LoginReset();

      expect(event1, event2);
    });
  });
}
