

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:topgrade/utils/color_manager.dart';

class SignupText extends StatelessWidget {
  final Function toggleView;
  const SignupText({Key? key, required this.toggleView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Don\'t have an account?  ',
            style: GoogleFonts.poppins(
              color: ColorManager.blackColor,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: 'Sign up',
                  style: GoogleFonts.poppins(
                      color: ColorManager.primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      toggleView();
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
