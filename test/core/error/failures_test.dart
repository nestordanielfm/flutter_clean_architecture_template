import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure should have message property', () {
      const failure = ServerFailure('Server error');
      expect(failure.message, 'Server error');
      expect(failure.props, ['Server error']);
    });

    test('NetworkFailure should have message property', () {
      const failure = NetworkFailure('Network error');
      expect(failure.message, 'Network error');
      expect(failure.props, ['Network error']);
    });

    test('CacheFailure should have message property', () {
      const failure = CacheFailure('Cache error');
      expect(failure.message, 'Cache error');
      expect(failure.props, ['Cache error']);
    });

    test('UnauthorizedFailure should have message property', () {
      const failure = UnauthorizedFailure('Unauthorized error');
      expect(failure.message, 'Unauthorized error');
      expect(failure.props, ['Unauthorized error']);
    });

    test('failures should be equal when messages are equal', () {
      const failure1 = ServerFailure('Error');
      const failure2 = ServerFailure('Error');
      expect(failure1, failure2);
    });

    test('failures should not be equal when messages differ', () {
      const failure1 = ServerFailure('Error 1');
      const failure2 = ServerFailure('Error 2');
      expect(failure1, isNot(failure2));
    });

    test('different failure types should not be equal', () {
      const failure1 = ServerFailure('Error');
      const failure2 = NetworkFailure('Error');
      expect(failure1, isNot(failure2));
    });
  });
}
