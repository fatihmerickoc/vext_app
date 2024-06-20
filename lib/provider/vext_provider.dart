import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vext_app/models/vext_model.dart';
part 'vext_provider.g.dart';

VextModel myVext = VextModel(
  "",
  [],
  "vext_network",
  100,
  false,
  false,
  'vext_plantStage',
  [],
);

//generated providers
@riverpod
VextModel vext(ref) {
  return myVext;
}
