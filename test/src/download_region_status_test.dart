import 'package:nb_maps_flutter/nb_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  group('DownloadRegionStatus', () {
    test('Success should be an instance of DownloadRegionStatus', () {
      // Arrange
      DownloadRegionStatus status = Success();

      // Assert
      expect(status, isA<DownloadRegionStatus>());
    });

    test('InProgress should be an instance of DownloadRegionStatus', () {
      // Arrange
      double progress = 0.5;
      DownloadRegionStatus status = InProgress(progress);

      // Assert
      expect(status, isA<DownloadRegionStatus>());
    });

    test('InProgress should have correct progress value', () {
      // Arrange
      double progress = 0.5;
      InProgress status = InProgress(progress);

      // Assert
      expect(status.progress, equals(progress));
    });

    test('InProgress should have correct toString representation', () {
      // Arrange
      double progress = 0.5;
      DownloadRegionStatus status = InProgress(progress);

      // Assert
      expect(
        status.toString(),
        "Instance of 'DownloadRegionStatus.InProgress', progress = $progress",
      );
    });

    test('Error should be an instance of DownloadRegionStatus', () {
      // Arrange
      PlatformException cause = PlatformException(code: 'error_code', message: 'error_message');
      DownloadRegionStatus status = Error(cause);

      // Assert
      expect(status, isA<DownloadRegionStatus>());
    });

    test('Error should have correct cause value', () {
      // Arrange
      PlatformException cause = PlatformException(code: 'error_code', message: 'error_message');
      Error status = Error(cause);

      // Assert
      expect(status.cause, equals(cause));
    });

    test('Error should have correct toString representation', () {
      // Arrange
      PlatformException cause = PlatformException(code: 'error_code', message: 'error_message');
      DownloadRegionStatus status = Error(cause);

      // Assert
      expect(
        status.toString(),
        "Instance of 'DownloadRegionStatus.Error', cause = ${cause.toString()}",
      );
    });
  });
}