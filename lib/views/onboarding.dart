import 'package:e_library/utils/colors.dart';
import 'package:e_library/views/login.dart';
import 'package:flutter/material.dart';
import 'package:e_library/models/onboarding_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();
  int currentPage = 0;

  Future<void> _setOnboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (v) {
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
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    spacing: 6,
                    children: List.generate(onboardingData.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? primaryColor
                              : greyColor, // Pastikan greyColor ada
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: currentPage == index ? 16 : 8,
                        height: 8,
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      if (currentPage == onboardingData.length - 1) {
                        _setOnboardingSeen();
                      } else {
                        pageController.animateToPage(currentPage + 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentPage == onboardingData.length - 1
                            ? 'Mulai Sekarang'
                            : 'Lanjutkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'InterSemiBold',
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
                currentPage == onboardingData.length - 1
                    ? const SizedBox(
                        height: 68,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                                onboardingData.length - 1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Lewati',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'InterSemiBold',
                                fontSize: 14,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
