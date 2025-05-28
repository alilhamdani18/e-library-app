import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/login.dart';
import 'package:flutter/material.dart';
import 'package:e_library/models/onboarding_data.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(4),
      child: Column(children: [
        Expanded(
          child: PageView.builder(
              controller: pageController,
              onPageChanged: (v) {
                // print(v.toString());
                setState(() {
                  currentPage = v;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingData[i]['image']),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Text(
                            onboardingData[i]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'InterBold',
                              fontSize: 28,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            onboardingData[i]['description'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'InterBold',
                              fontSize: 16,
                              color: textGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                spacing: 6,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                        color: currentPage == 0 ? primaryColor : greyColor,
                        borderRadius: BorderRadius.circular(8)),
                    width: currentPage == 0 ? 16 : 8,
                    height: 8,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                        color: currentPage == 1 ? primaryColor : greyColor,
                        borderRadius: BorderRadius.circular(8)),
                    width: currentPage == 1 ? 16 : 8,
                    height: 8,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                        color: currentPage == 2 ? primaryColor : greyColor,
                        borderRadius: BorderRadius.circular(8)),
                    width: currentPage == 2 ? 16 : 8,
                    height: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  if (currentPage == 2) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => const Login()));
                  } else {
                    pageController.animateToPage(currentPage + 1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    currentPage == 2 ? 'Mulai Sekarang' : 'Lanjutkan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'InterSemiBold',
                        fontSize: 14,
                        color: textColor),
                  ),
                ),
              ),
            ),
            currentPage == 2
                ? SizedBox(
                    height: 68,
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        pageController.animateToPage(2,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'Lewati',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'InterSemiBold',
                              fontSize: 14,
                              color: primaryColor),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ]),
    ));
  }
}
