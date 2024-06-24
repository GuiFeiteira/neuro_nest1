import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class EducationalResources extends StatelessWidget {
  const EducationalResources({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.educationalResources,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        _buildLinkCard(
          context,
          title: AppLocalizations.of(context)!.site1Title,
          description: AppLocalizations.of(context)!.site1Description,
          url: 'https://www.epilepsy.com/',
        ),
        _buildLinkCard(
          context,
          title: AppLocalizations.of(context)!.site2Title,
          description: AppLocalizations.of(context)!.site2Description,
          url: 'https://epilepsia.pt/epilepsia-e-dieta-cetogenica/',
        ),
        _buildLinkCard(
          context,
          title: AppLocalizations.of(context)!.site3Title,
          description: AppLocalizations.of(context)!.site3Description,
          url: 'https://www.mayoclinic.org/diseases-conditions/epilepsy/symptoms-causes/syc-20350093',
        ),
      ],
    );
  }

  Widget _buildLinkCard(BuildContext context, {required String title, required String description, required String url}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.open_in_new),
        onTap: () => _launchURL(url),
      ),
    );
  }
}
