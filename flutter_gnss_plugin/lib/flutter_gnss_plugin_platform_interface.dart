import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_gnss_plugin_method_channel.dart';

abstract class FlutterGnssPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterGnssPluginPlatform.
  FlutterGnssPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGnssPluginPlatform _instance = MethodChannelFlutterGnssPlugin();

  /// The default instance of [FlutterGnssPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGnssPlugin].
  static FlutterGnssPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGnssPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterGnssPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
