import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';

class KindergartenStageScreenV4 extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreenV4({super.key, required this.stageId});
  bool get kg2 => stageId == 'kg2';

  @override