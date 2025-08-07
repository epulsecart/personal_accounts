import 'package:accounts/ui/group/widgets/loading_placeholder.dart';
import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

class ProjectsModule extends StatefulWidget {
  const ProjectsModule({super.key});

  @override
  State<ProjectsModule> createState() => _ProjectsModuleState();
}

class _ProjectsModuleState extends State<ProjectsModule> {
  @override
  Widget build(BuildContext context) {
    return  LoadingPlaceholder(
      text: S.of(context).projectIsComing,
    );
  }
}
