import 'package:couver_ui/couver_ui.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const Card(
        elevation: 6,
        child: Text('Flutter card'),
      ),
      CCard(
        onTap: () {},
        padding: const EdgeInsets.all(16),
        child: const Text('Material'),
      ),
      CCard(
        inkOnTop: false,
        onTap: () {},
        padding: const EdgeInsets.all(16),
        child: const Text('inkOnTop:false'),
      ),
      CCard(
        platformStyle: PlatformStyle.cupertino,
        onTap: () {},
        padding: const EdgeInsets.all(16),
        decorationImage: const DecorationImage(
          image: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
          ),
        ),
        child: const Text('cupertino'),
      ),
      CCard(
        platformStyle: PlatformStyle.cupertino,
        cupertinoOption: const CInkCupertinoOption(
            cupertinoInkStyle: CupertinoInkStyle.shade),
        onTap: () {},
        padding: const EdgeInsets.all(16),
        decorationImage: const DecorationImage(
          image: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
          ),
        ),
        child: const Text('cupertino shade'),
      ),
      CCard(
        platformStyle: PlatformStyle.cupertino,
        cupertinoOption: const CInkCupertinoOption(
            cupertinoInkStyle: CupertinoInkStyle.scale),
        onTap: () {},
        padding: const EdgeInsets.all(16),
        decorationImage: const DecorationImage(
          image: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
          ),
        ),
        child: const Text('cupertino scale'),
      ),
    ]
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(8),
            child: e,
          ),
        )
        .toList();
    return Screen(
      child: Column(
        children: [
          Column(
            children: children,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ],
      ),
    );
  }
}
