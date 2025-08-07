import 'dart:convert';

import 'package:accounts/generated/l10n.dart';
import 'package:accounts/state/auth_provider.dart';
import 'package:accounts/state/group_module/group_join_request_provider.dart';
import 'package:accounts/state/group_module/group_provider.dart';
import 'package:accounts/data/groups_module/group_join_request_model.dart';
import 'package:accounts/data/groups_module/group_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class JoinRequestsTabView extends StatelessWidget {
  final GroupModel group;
  const JoinRequestsTabView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final groupProvider = context.watch<GroupProvider>();
    final joinProvider  = context.watch<GroupJoinRequestProvider>();
    final auth          = context.read<AuthProvider>();
    final userId        = auth.user!.uid;
    final tempMap = {
      'groupId': group.id,
      'inviteeId': userId,
      'inviteeName': auth.user?.name??'',
    };
    String encodedData = base64Encode(utf8.encode(jsonEncode(tempMap)));
    // final nextEncode = utf8.encode(encodedData);

    // Only admin can manage
    final isAdmin = group.createdBy == userId;
    if (!isAdmin) {
      return Center(child: Text(t.onlyAdminsCanViewRequests));
    }

    final requests = joinProvider.requests.where((r) => r.status == JoinStatus.pending).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: ()async{
          await context.read<GroupJoinRequestProvider>().synchronize();
        },
        child: ListView(
          shrinkWrap: true,

          children: [
            // 🔗 Share Info
            Text(t.shareGroupInfo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // 📷 QR Code
            Center(
              child: QrImageView(
                data: encodedData,
                size: 200,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text(t.scanToJoin),
                  const SizedBox(height: 6),
                  SelectableText(encodedData, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1,),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: encodedData));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t.copyJoinCode)),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: Text(t.copyJoinCode),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Text(t.pendingRequests, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            if (joinProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (requests.isEmpty)
              Center(child: Text("🎉 ${t.noData}"))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, i) {
                  final req = requests[i];
                  return Card(
                    child: ListTile(
                      title: Text('${t.requester}: ${req.requesterName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${t.invitee}: ${req.inviteeName}'),
                          Text('${t.requestDate}: ${req.requestedAt.toLocal()}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () async {
                              await joinProvider.approveRequest(req);
                              // 👥 Add to members list
                              final updatedMembers = [...group.memberIds];
                              updatedMembers.add({req.requesterId: req.requesterName});
                              final updatedGroup = group.copyWith(
                                memberIds: updatedMembers,
                                updatedAt: DateTime.now(),
                              );
                              await groupProvider.updateGroup(updatedGroup);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.approvedSuccessfully)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              await joinProvider.rejectRequest(req);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.rejectedSuccessfully)),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
