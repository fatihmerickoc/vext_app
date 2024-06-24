import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:vext_app/models/vext_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'vext_notifier.g.dart';

@riverpod
class VextNotifier extends _$VextNotifier {
  static const thingsBoardApiEndpoint = 'https://thingsboard.vinicentus.net';

  //FIXME: get the inital value from Shared Preferences later;
  @override
  VextModel build() {
    return VextModel(
      "test_id",
      [],
      "text_network",
      222,
      false,
      false,
      'test_plantStage',
      [],
    );
  }

  //method to update state
  void updateVext(VextModel vext) {
    if (state != vext) {
      state = vext;
    }
  }
}
