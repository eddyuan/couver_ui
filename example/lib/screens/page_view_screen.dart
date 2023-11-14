import 'package:couver_ui/couver_ui.dart';
import 'package:example/constants/c_theme.dart';
import 'package:example/screens/screen.dart';
import 'package:flutter/material.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  List<Widget> buildChildren() {
    return List.generate(
      20,
      (index) => Container(
        decoration: BoxDecoration(
          color: CTheme.rColor(index),
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: Text(
            index.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildChildrenWithPadding() {
    return buildChildren()
        .map((e) => Padding(
              padding: const EdgeInsets.all(8),
              child: e,
            ))
        .toList();
  }

  final CPageController controller = CPageController(initialPage: 0);

  double itemWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Screen(
      child: Column(
        children: [
          Row(
            children: [
              CButton.filled(
                text: "-",
                onPressed: () {
                  controller.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                },
              ),
              CButton.filled(
                text: "+",
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                },
              ),
              CButton.filled(
                text: "W-",
                onPressed: () {
                  setState(() {
                    itemWidth -= 10;
                  });
                },
              ),
              CButton.filled(
                text: "W+",
                onPressed: () {
                  setState(() {
                    itemWidth += 10;
                  });
                },
              ),
            ],
          ),
          CPageView(
            controller: controller,
            itemWidth: itemWidth,
            inactiveScale: 0.9,
            children: buildChildren(),
            // gap: 0,
          ),
          LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.all(24.0),
                itemBuilder: (context, index) =>
                    SizedBox(width: itemWidth, child: buildChildren()[index]),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                controller: PageController(
                    viewportFraction: (itemWidth + 10) / constraints.maxWidth),
                physics: const PageScrollPhysics(),
              ),
            );
          }),
          SizedBox(
            height: 200,
            child: PageView(
              pageSnapping: true,
              controller: PageController(
                viewportFraction: 0.8,
              ),
              children: buildChildren(),
            ),
          ),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: PageView(
                clipBehavior: Clip.none,
                allowImplicitScrolling: true,
                padEnds: false,
                controller: PageController(
                  viewportFraction: itemWidth / 750,
                ),
                children: buildChildrenWithPadding(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
