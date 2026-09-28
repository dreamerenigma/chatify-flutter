import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../chat/models/user_model.dart';
import '../../personalization/widgets/dialogs/light_dialog.dart';
import '../models/survey_model.dart';
import '../widgets/tiles/voter_tile.dart';

class DataSurveyScreen extends StatelessWidget {
  final UserModel user;
  final String conversationId;
  final String messageId;
  final SurveyModel survey;
  final String selectedOption;

  const DataSurveyScreen({
    super.key,
    required this.user,
    required this.conversationId,
    required this.messageId,
    required this.survey,
    required this.selectedOption,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> _votesStream() {
    return FirebaseFirestore.instance.collection('Chats').doc(conversationId).collection('messages').doc(messageId).collection('votes').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Text('Данные опроса', style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.w400)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _votesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorsController.getColor(colorsController.selectedColorScheme.value), strokeWidth: 3));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Не удалось загрузить голоса'));
          }

          final votes = snapshot.data?.docs ?? [];

          final voters = votes.where((doc) {
            final data = doc.data();
            final selectedOptions = List<String>.from(data['selectedOptions'] ?? []);

            return selectedOptions.contains(selectedOption);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 30, top: 18, bottom: 8),
                child: Text(survey.question, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.w400)),
              ),
              Divider(height: 8, thickness: 8, color: ChatifyColors.nightGrey),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Text(selectedOption, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1.5)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.how_to_vote_outlined, size: 15, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 4),
                    Text('Голоса: ${voters.length}', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, thickness: 2, color: ChatifyColors.nightGrey),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: voters.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final vote = voters[index];

                  return VoterTile(votedAt: vote.data()['votedAt'], user: user,);
                },
              ),
              Divider(height: 8, thickness: 8, color: ChatifyColors.nightGrey),
              ...survey.options.map((option) {
                if (option == selectedOption) {
                  return const SizedBox.shrink();
                }

                final optionVoters = votes.where((doc) {
                  final data = doc.data();
                  final selectedOptions = List<String>.from(data['selectedOptions'] ?? []);

                  return selectedOptions.contains(option);
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(option, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 4),
                          Text('Голоса: ${optionVoters.length}', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              Divider(height: 1, thickness: 2, color: ChatifyColors.nightGrey),
            ],
          );
        },
      ),
    );
  }
}
