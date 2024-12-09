import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Developer Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              // Creator Profile Cards
              CreatorProfileCard(
                image: 'assets/profiles/profile_ali.png', // Add your image path
                name: 'Ali Musthofa',
                role: 'Mobile Developer',
                description: 'Mahasiswa Informatika',
                linkedinUrl:
                    'https://www.linkedin.com/in/alimusthofabaharudin/',
              ),
              SizedBox(height: 16),
              CreatorProfileCard(
                image:
                    'assets/profiles/profile_aqsha.png', // Add your image path
                name: 'Aqsha Maulana Ilham',
                role: 'Project Manager',
                description: 'Mahasiswa Informatika',
                linkedinUrl: 'https://www.linkedin.com/in/aqshamaulana/',
              ),
              SizedBox(height: 16),
              CreatorProfileCard(
                image:
                    'assets/profiles/profile_arum.png', // Add your image path
                name: 'Arum Sita Resmi',
                role: 'UI/UX Designer',
                description: 'Mahasiswa Informatika',
                linkedinUrl:
                    'https://www.linkedin.com/in/arum-sita-resmi-a2a203233/',
              ),
              SizedBox(height: 16),
              CreatorProfileCard(
                image:
                    'assets/profiles/profile_dandi.png', // Add your image path
                name: 'M Dandi Al Idrus',
                role: 'Quality Assurance',
                description: 'Mahasiswa Informatika',
                linkedinUrl:
                    'https://www.linkedin.com/in/m-dandi-al-idrus-b219a1247/',
              ),
              // Add more profiles as needed
            ],
          ),
        ),
      ),
    );
  }
}

class CreatorProfileCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final String description;
  final String linkedinUrl;

  const CreatorProfileCard({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    required this.description,
    required this.linkedinUrl,
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(linkedinUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: _launchURL,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
