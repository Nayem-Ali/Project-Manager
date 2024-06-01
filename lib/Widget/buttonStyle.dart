import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

buttonStyle(int width, int height) => ElevatedButton.styleFrom(
      minimumSize: Size(width.w, 10+height.h),
      textStyle: GoogleFonts.adamina(
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    );
