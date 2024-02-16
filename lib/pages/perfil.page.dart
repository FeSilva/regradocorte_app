import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

void main() {
  runApp(MaterialApp(
    home: Profile(),
  ));
}

class UserProfile {
  final String name;
  final List<Award> awards;
  final List<String> photoAssetPaths;
  final List<ProfileInfoItem> profileInfo;

  UserProfile({
    required this.name,
    required this.awards,
    required this.photoAssetPaths,
    required this.profileInfo,
  });
}

class Award {
  final String title;
  final String year;
  final String imageUrl;
  final Color borderColor;

  Award(this.title, this.year, this.borderColor, this.imageUrl);
}

class Profile extends StatelessWidget {
  final UserProfile user = UserProfile(
    name: "Richie Lorie",
    awards: [
      Award("Regra do Corte", "2024", Colors.blue, 'assets/images/cabelo.jpeg'),
      Award("Melhor Corte", "2025", Colors.green, 'assets/images/background.png'),
    ],
    photoAssetPaths: [
      'assets/images/background.png',
      'assets/images/cabelo.jpeg',
      'assets/images/logo.jpg',
      'assets/images/background.png',
      'assets/images/cabelo.jpeg',
      'assets/images/logo.jpg',
    ],
    profileInfo: [
      ProfileInfoItem("Cortes", 200),
      ProfileInfoItem("Realizados", 500),
      ProfileInfoItem("Pontuação", 900),
    ],
  );

  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion(user: user)),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Prêmios Ganhos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: user.awards.map((award) {
                          return _AwardsCard(award);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Portfolio",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _buildPhotoGrid(context, user.photoAssetPaths),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, List<String> photoAssetPaths) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: photoAssetPaths.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showPhotoView(context, photoAssetPaths, index);
          },
          child: Image.asset(
            photoAssetPaths[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  void _showPhotoView(BuildContext context, List<String> photoAssetPaths, int currentIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PhotoViewGalleryScreen(
          photoAssetPaths: photoAssetPaths,
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}

class _PhotoViewGalleryScreen extends StatelessWidget {
  final List<String> photoAssetPaths;
  final int currentIndex;

  const _PhotoViewGalleryScreen({
    required this.photoAssetPaths,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoViewGallery.builder(
          itemCount: photoAssetPaths.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: AssetImage(photoAssetPaths[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: PageController(initialPage: currentIndex),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Cortes", 900),
    ProfileInfoItem("Realizados", 120),
    ProfileInfoItem("Pontuação", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
          .map((item) => Expanded(
                child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                ),
              ))
          .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        item.value.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      Text(
        item.title,
        style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.white),
      )
    ],
  );
}

class _AwardsCard extends StatelessWidget {
  final Award award;

  const _AwardsCard(this.award, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: award.borderColor, width: 2.0),
              ),
              child: ClipOval(
                child: Image.asset(
                  award.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              award.title,
              style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.white),
            ),
            Text(
              award.year,
              style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoItem {
  final String title;
  final int value;

  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  final UserProfile user;

  const _TopPortion({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 100),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/cabelo.jpeg'),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(user.photoAssetPaths.first),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text("Follow"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message_rounded),
                      label: const Text("Message"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: user.profileInfo.map((info) {
                    return _buildInfoColumn(context, info);
                  }).toList(),
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(BuildContext context, ProfileInfoItem info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          info.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          info.value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
