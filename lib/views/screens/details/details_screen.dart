

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:topgrade/helpers/helper.dart';
import 'package:topgrade/models/courses_model.dart';
import 'package:topgrade/models/my_courses_model.dart';
import 'package:topgrade/models/payment_gateway_model.dart';
import 'package:topgrade/routes/appPages.dart';
import 'package:topgrade/utils/values_manager.dart';
import 'package:topgrade/views/screens/details/widgets/instructor_screen.dart';
import '../../../controllers/add_favorite_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/payment_gateway_controller.dart';
import '../../../helpers/text_helper.dart';
import '../../../models/cart_model.dart';
import '../../../models/wishlist_model.dart';
import '../../../utils/color_manager.dart';
import '../../../utils/strings_manager.dart';
import 'widgets/description_screen.dart';
import 'package:get/get.dart';
import 'widgets/payment_sheet.dart';
import 'widgets/playlist_screen.dart';

class DetailsScreen extends StatefulWidget {
  CoursesModel? coursesDetail;
  MyCoursesModel? myCoursesModel;
  DataItem? favCourseDetail;
  bool isWishlist;
  DetailsScreen({Key? key, this.coursesDetail, this.favCourseDetail, required this.isWishlist}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin{

  late TabController _controller;
  var cartController = Get.put(CartController());
  var addFavController = Get.put(AddFavoriteController());
  var paymentGatewayController = Get.put(PaymentGatewayController());
  List<PaymentGatewayModel> paymentGatewayModel = [];
  final box = GetStorage();
  List<String> myCoursesId = [];
  bool isPaid = false;
  String? isMyCourse;

  @override
  void initState() {
    super.initState();
    initalize();
    checkPayment();
  }

  initalize() {
    var data = Get.arguments;
    String? check =  Get.parameters['isWishlist'];
    isMyCourse =  Get.parameters['isMyCourse'];
    check == "true" ? widget.isWishlist = true : widget.isWishlist = false;
    isMyCourse == "true" ? widget.myCoursesModel = data :
    widget.isWishlist == false ? widget.coursesDetail = data : widget.favCourseDetail = data;
    _controller = TabController(length: 3, vsync: this);
    myCoursesId = box.read("myCoursesId").cast<String>();
    cartController.open();

  }

  checkPayment() {
    if(myCoursesId.isNotEmpty){
      if(widget.isWishlist == true){
        for(int i=0; i<myCoursesId.length; i++){
          if(widget.favCourseDetail!.id.toString() == myCoursesId[i]){
            setState(() { isPaid = true; });
          }
        }
      }
      else if(isMyCourse == "true"){
        for(int i=0; i<myCoursesId.length; i++){
          if(widget.myCoursesModel!.id.toString() == myCoursesId[i]){
            setState(() { isPaid = true; });
          }
        }
      }
      else{
        for(int i=0; i<myCoursesId.length; i++){
          if(widget.coursesDetail!.id.toString() == myCoursesId[i]){
            setState(() { isPaid = true; });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      appBar: buildAppBar(),
      body: widget.isWishlist ?
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSpaceVertical(1.h),
            SizedBox(
                height: 28.h,
                width: 100.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 27.h,
                        width: 90.w,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppSize.s10),
                                topRight: Radius.circular(AppSize.s10),
                                bottomLeft: Radius.circular(AppSize.s10),
                                bottomRight: Radius.circular(AppSize.s10)),
                            child: Image.network(widget.favCourseDetail!.image!, fit: BoxFit.fill)),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 15,
                      child: Container(
                        height: 6.h,
                        width: 20.w,
                        decoration: const BoxDecoration(
                            color: ColorManager.redColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSize.s10),
                              bottomLeft: Radius.circular(AppSize.s10),
                              topRight: Radius.circular(AppSize.s10),
                              bottomRight: Radius.circular(AppSize.s10),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle0(text: "Price", color: ColorManager.whiteColor),
                            textStyle0(text: "\$${widget.favCourseDetail!.price.toString()}", color: ColorManager.whiteColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            buildSpaceVertical(1.h),
            buildSpaceVertical(2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Title"),
                      textStyle2(text: widget.favCourseDetail!.name!),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Rating"),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p34),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle0(text: widget.favCourseDetail!.rating!.toString()),
                            buildSpaceHorizontal(0.5.w),
                            textStyle0(text: "⭐"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildSpaceVertical(2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Teacher"),
                      textStyle0_5(text: widget.favCourseDetail!.instructor!.name!),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Sections"),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p40),
                        child: textStyle0_5(text: "${widget.favCourseDetail!.sections!.length}"),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            buildSpaceVertical(2.h),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p6, horizontal: AppPadding.p22),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(color: ColorManager.redColor, borderRadius: BorderRadius.circular(AppSize.s22)),
                controller: _controller,
                unselectedLabelColor: ColorManager.blackColor,
                unselectedLabelStyle: const TextStyle(color: ColorManager.blackColor),
                tabs: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                          child: Text("Overview", style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),),
                      )
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Curriculum", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Instructor", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: _controller,
                children: [
                  OverviewScreen(favCourseDetail: widget.favCourseDetail, isWishlist: true, isMyCourse: "false"),
                  Playlist(favCourseDetail: widget.favCourseDetail, isWishlist: true, isMyCourse: "false"),
                  InstructorScreen(favCourseDetail: widget.favCourseDetail, isWishlist: true, isMyCourse: "false"),
                ],
              ),
            )

          ],
        ),
      )
      :
      isMyCourse == "true" ?
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSpaceVertical(1.h),
            SizedBox(
                height: 28.h,
                width: 100.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 27.h,
                        width: 90.w,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppSize.s10),
                                topRight: Radius.circular(AppSize.s10),
                                bottomLeft: Radius.circular(AppSize.s10),
                                bottomRight: Radius.circular(AppSize.s10)),
                            child: Image.network(widget.myCoursesModel!.image!, fit: BoxFit.fill)),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 15,
                      child: Container(
                        height: 6.h,
                        width: 20.w,
                        decoration: const BoxDecoration(
                            color: ColorManager.redColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSize.s10),
                              bottomLeft: Radius.circular(AppSize.s10),
                              topRight: Radius.circular(AppSize.s10),
                              bottomRight: Radius.circular(AppSize.s10),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle0(text: "Price", color: ColorManager.whiteColor),
                            textStyle0(text: "\$${widget.myCoursesModel!.price.toString()}", color: ColorManager.whiteColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            buildSpaceVertical(1.h),
            buildSpaceVertical(2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Title"),
                      textStyle2(text: widget.myCoursesModel!.name!),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Rating"),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p34),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle0(text: widget.myCoursesModel!.rating!.toString()),
                            buildSpaceHorizontal(0.5.w),
                            textStyle0(text: "⭐"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildSpaceVertical(2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Teacher"),
                      textStyle0_5(text: widget.myCoursesModel!.instructor!.name!.name),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Sections"),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p40),
                        child: textStyle0_5(text: "${widget.myCoursesModel!.sections!.length}"),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            buildSpaceVertical(2.h),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p6, horizontal: AppPadding.p22),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(color: ColorManager.redColor, borderRadius: BorderRadius.circular(AppSize.s22)),
                controller: _controller,
                unselectedLabelColor: ColorManager.blackColor,
                unselectedLabelStyle: const TextStyle(color: ColorManager.blackColor),
                tabs: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Overview", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Curriculum", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Instructor", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: _controller,
                children: [
                  OverviewScreen(myCoursesModel: widget.myCoursesModel, isWishlist: false, isMyCourse: "true"),
                  Playlist(myCoursesModel: widget.myCoursesModel, isWishlist: false, isMyCourse: "true"),
                  InstructorScreen(myCoursesModel: widget.myCoursesModel, isWishlist: false, isMyCourse: "true"),
                ],
              ),
            )

          ],
        ),
      )
      :
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSpaceVertical(1.h),
            SizedBox(
                height: 28.h,
                width: 100.w,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 27.h,
                        width: 90.w,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(AppSize.s10),
                                topRight: Radius.circular(AppSize.s10),
                                bottomLeft: Radius.circular(AppSize.s10),
                                bottomRight: Radius.circular(AppSize.s10)),
                            child: Image.network(widget.coursesDetail!.image!, fit: BoxFit.fill)),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 15,
                      child: Container(
                        height: 6.h,
                        width: 20.w,
                        decoration: const BoxDecoration(
                            color: ColorManager.redColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppSize.s10),
                              bottomLeft: Radius.circular(AppSize.s10),
                              topRight: Radius.circular(AppSize.s10),
                              bottomRight: Radius.circular(AppSize.s10),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle0(text: "Price", color: ColorManager.whiteColor),
                            textStyle0(text: "\$${widget.coursesDetail!.price.toString()}", color: ColorManager.whiteColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            buildSpaceVertical(1.h),
            buildSpaceVertical(2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Title"),
                      textStyle2(text: widget.coursesDetail!.name!),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Rating"),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p34),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textStyle0(text: widget.coursesDetail!.rating!.toString()),
                            buildSpaceHorizontal(0.5.w),
                            textStyle0(text: "⭐"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            buildSpaceVertical(2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Teacher"),
                      textStyle0_5(text: widget.coursesDetail!.instructor!.name!.name),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textStyle0(text: "Course Sections"),
                      Padding(
                        padding: const EdgeInsets.only(left: AppPadding.p40),
                        child: textStyle0_5(text: "${widget.coursesDetail!.sections!.length}"),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            buildSpaceVertical(2.h),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p6, horizontal: AppPadding.p22),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(color: ColorManager.redColor, borderRadius: BorderRadius.circular(AppSize.s22)),
                controller: _controller,
                unselectedLabelColor: ColorManager.blackColor,
                unselectedLabelStyle: const TextStyle(color: ColorManager.blackColor),
                tabs: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Overview", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Curriculum", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 4.h,
                      child: Tab(
                        child: Text("Instructor", style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: _controller,
                children: [
                  OverviewScreen(coursesDetail: widget.coursesDetail, isWishlist: false, isMyCourse: "false"),
                  Playlist(coursesDetail: widget.coursesDetail, isWishlist: false, isMyCourse: "false"),
                  InstructorScreen(coursesDetail: widget.coursesDetail, isWishlist: false, isMyCourse: "false"),
                ],
              ),
            )

          ],
        ),
      ),
      bottomSheet: SizedBox(
          height: 7.h, width: 100.w,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppPadding.p10),
            child: buildBottomCard(),
          )
      ),
    );
  }

  Center buildBottomCard() {
    return Center(
      child: isPaid == true ?
      InkWell(
        onTap: () {
          Get.toNamed(Paths.lessons, arguments: widget.coursesDetail!.sections);
        },
        child: Container(
          height: 6.h,
          width: 60.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s12),
              color: ColorManager.primaryColor
          ),
          child: Center(child: textStyle2(text: "Start Now", color: ColorManager.whiteColor)),
        ),
      )
      :
      Obx(() {
          if(paymentGatewayController.isLoading.value){
           return const Center(child: CircularProgressIndicator());
          }else{
            paymentGatewayModel.clear();
            for(int i=0; i<paymentGatewayController.gatewayList.length; i++){
              if(paymentGatewayController.gatewayList[i].enabled == true){
                paymentGatewayModel.add(paymentGatewayController.gatewayList[i]);
              }
            }
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    builder: (context) {
                      return StatefulBuilder(builder: (context, StateSetter customSetState) {
                        return PaymentSheet(paymentGatewayModel: paymentGatewayModel);
                      });
                    });
              },
              child: Container(
                height: 6.h,
                width: 60.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                    color: ColorManager.primaryColor
                ),
                child: Center(child: textStyle2(text: "Buy Now", color: ColorManager.whiteColor)),
              ),
            );
          }

      }),
    );
  }

  AppBar buildAppBar() {
    return widget.isWishlist ?
    AppBar(
      title: textStyle2(text: StringsManager.details),
      centerTitle: false,
      backgroundColor: ColorManager.whiteColor,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: ColorManager.blackColor),
      actions: [
        InkWell(
          onTap: () {
            addFavController.addFavorite(widget.favCourseDetail!.id.toString()).then((response) => {
              if(response['status'] == 'success') {
                successToast("Success", "Course Added to Wishlist"),
              }else{
                errorToast("Error", "Failed to Add Course to Wishlist")
              }
            });
          },
          child: Container(
            height: 5.h,
            width: 5.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s16),
              color: ColorManager.whiteColor
            ),
            child: Obx(() {
              return addFavController.isDataSubmitting.value == true ? const Center(child: CircularProgressIndicator()) :
              const Icon(Icons.favorite, color: ColorManager.redColor);
            }),
          ),
        ),
        buildSpaceHorizontal(9.w),
        InkWell(
          onTap: (){
            CartModel cart = CartModel(
                quantity: 1, productId: widget.favCourseDetail!.id.toString(),
                price: double.parse(widget.favCourseDetail!.price.toString()),
                name: widget.favCourseDetail!.name, image: widget.favCourseDetail!.image);

            cartController.insert(cart).then((value) => {
              if(value.name != null){
                successToast("Success", "Course Added to Cart Successfully"),
                Get.toNamed(Paths.cart),
              }else{
                errorToast("Error", "Failed to Add Course to Cart")
              }
            });

          },
          child: const Center(child: Icon(Icons.shopping_cart, color: ColorManager.redColor, size: 30)),
        ),
        buildSpaceHorizontal(5.w),
      ],
    )
    :
    isMyCourse == "true" ?
    AppBar(
      title: textStyle2(text: StringsManager.details),
      centerTitle: false,
      backgroundColor: ColorManager.whiteColor,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: ColorManager.blackColor),
      actions: [
        InkWell(
          onTap: () {
            addFavController.addFavorite(widget.myCoursesModel!.id.toString()).then((response) => {
              if(response['status'] == 'success') {
                successToast("Success", "Course Added to Wishlist"),
              }else{
                errorToast("Error", "Failed to Add Course to Wishlist")
              }
            });
          },
          child: Container(
            height: 5.h,
            width: 5.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s16),
                color: ColorManager.whiteColor
            ),
            child: Obx(() {
              return addFavController.isDataSubmitting.value == true ? const Center(child: CircularProgressIndicator()) :
              const Icon(Icons.favorite, color: ColorManager.redColor);
            }),
          ),
        ),
        buildSpaceHorizontal(9.w),
        InkWell(
          onTap: (){
            CartModel cart = CartModel(
                quantity: 1, productId: widget.myCoursesModel!.id.toString(),
                price: double.parse(widget.myCoursesModel!.price.toString()),
                name: widget.myCoursesModel!.name, image: widget.myCoursesModel!.image);

            cartController.insert(cart).then((value) => {
              if(value.name != null){
                successToast("Success", "Course Added to Cart Successfully"),
                Get.toNamed(Paths.cart),
              }else{
                errorToast("Error", "Failed to Add Course to Cart")
              }
            });

          },
          child: const Center(child: Icon(Icons.shopping_cart, color: ColorManager.redColor, size: 30)),
        ),
        buildSpaceHorizontal(5.w),
      ],
    )
    :
    AppBar(
      title: textStyle2(text: StringsManager.details),
      centerTitle: false,
      backgroundColor: ColorManager.whiteColor,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: ColorManager.blackColor),
      actions: [
        InkWell(
          onTap: () {
            addFavController.addFavorite(widget.coursesDetail!.id.toString()).then((response) => {
              if(response['status'] == 'success') {
                successToast("Success", "Course Added to Wishlist"),
              }else{
                errorToast("Error", "Failed to Add Course to Wishlist")
              }
            });
          },
          child: Container(
            height: 5.h,
            width: 5.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s16),
                color: ColorManager.whiteColor
            ),
            child: Obx(() {
              return addFavController.isDataSubmitting.value == true ? const Center(child: CircularProgressIndicator()) :
              const Icon(Icons.favorite, color: ColorManager.redColor);
            }),
          ),
        ),
        buildSpaceHorizontal(9.w),
        InkWell(
          onTap: (){
            CartModel cart = CartModel(
                quantity: 1, productId: widget.coursesDetail!.id.toString(),
                price: double.parse(widget.coursesDetail!.price.toString()),
                name: widget.coursesDetail!.name, image: widget.coursesDetail!.image);

            cartController.insert(cart).then((value) => {
              if(value.name != null){
                successToast("Success", "Course Added to Cart Successfully"),
                Get.toNamed(Paths.cart),
              }else{
                errorToast("Error", "Failed to Add Course to Cart")
              }
            });

          },
          child: const Center(child: Icon(Icons.shopping_cart, color: ColorManager.redColor, size: 30)),
        ),
        buildSpaceHorizontal(5.w),
      ],
    );
  }

}
