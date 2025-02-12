import 'package:flutter/material.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';

class KProposalView extends StatelessWidget {
  final ProposalModel proposal;

  const KProposalView({Key? key, required this.proposal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              proposal.title ?? "Untitled Proposal",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ID
            Text(
              "ID: ${proposal.id ?? '-'}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 20, thickness: 2),

            // Supervisor
            Text(
              "Supervisor: ${proposal.supervisor ?? 'Not Assigned'}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const Divider(height: 20, thickness: 2,),

            // Team Members Section
            Text(
              "Team Members (${proposal.totalMembers ?? 0}):",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._buildMemberWidgets(proposal.members ?? []),

            const Divider(height: 20, thickness: 2),

            // Proposal Drive Link
            if (proposal.proposal != null && proposal.proposal!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  // TODO: Handle opening the proposal link
                },
                child: Text(
                  "Proposal Link: ${proposal.proposal}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),


          ],
        ),
      ),
    );
  }

  // Helper to build widgets for each team member
  List<Widget> _buildMemberWidgets(List<Member> members) {
    return members.map((member) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${member.name ?? '-'}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Student ID: ${member.studentId ?? '-'}"),
            Text("Email: ${member.email ?? '-'}"),
            Text("Phone: ${member.mobile ?? '-'}"),
            Text("CGPA: ${member.cgpa ?? '-'}"),
          ],
        ),
      );
    }).toList();
  }
}
