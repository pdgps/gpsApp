import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gnss_plugin/flutter_gnss_plugin.dart';
import 'package:flutter_gnss_plugin/flutter_gnss_plugin_platform_interface.dart';
import 'package:flutter_gnss_plugin/flutter_gnss_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterGnssPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterGnssPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterGnssPluginPlatform initialPlatform = FlutterGnssPluginPlatform.instance;

  test('$MethodChannelFlutterGnssPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterGnssPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterGnssPlugin flutterGnssPlugin = FlutterGnssPlugin();
    MockFlutterGnssPluginPlatform fakePlatform = MockFlutterGnssPluginPlatform();
    FlutterGnssPluginPlatform.instance = fakePlatform;

    expect(await flutterGnssPlugin.getPlatformVersion(), '42');
  });
}
