import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PromptCreatorStepperScreen extends HookConsumerWidget {
  const PromptCreatorStepperScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final stepIndex = useState(0);

    final stepsProgress = useState(stepIndex.value + 1 / steps.length);
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsetsDirectional.only(end: 10, top: 16),
          width: double.infinity,
          child: Column(
            children: [
              CloseButton(),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                width: double.infinity,
                child: LinearProgressIndicator(
                  value: stepsProgress.value,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(15),
                  valueColor: AlwaysStoppedAnimation(Color(0xffEFB036)),
                  backgroundColor: Color(0xff4C7B8B),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              steps[stepIndex.value],
              Container(
                  height: 44,
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xffEFB036),
                      ),
                    ),
                    child: Text(
                      'continue',
                      style: TextStyle(color: Color(0xff282828), fontSize: 15),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: IconButton(
            onPressed: () {
              context.maybePop();
            },
            icon: Icon(Icons.close)));
  }
}

List<Widget> steps = [
  Builder(builder: (context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Text(
              'we can provide more efficient schedule based on a clear photo of you..'),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImagePickerContainer(
                height: 300,
                width: 165,
                icon: Icon(EneftyIcons.camera_outline,
                    color: Color(0xff282828).withValues(alpha: .8)),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => SimpleDialog(
                      titleTextStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff282828),
                          fontFamily: 'Tajawal'),
                      backgroundColor: Colors.white.withOpacity(.9),
                      elevation: 0,
                      title: Text('would You Like To'),
                      children: <Widget>[
                        SimpleDialogOption(
                          child: Text('select From Gallery'),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        SimpleDialogOption(
                          child: Text('take a photo'),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                text: 'Here upload \nfull length image',
              ),
              Column(
                children: [
                  ImagePickerContainer(
                    width: 165,
                    height: 145,
                    icon: SizedBox.shrink(),
                    text: 'Here upload \nhead shot',
                  ),
                  ImagePickerContainer(
                    width: 165,
                    height: 145,
                    icon: SizedBox.shrink(),
                    text: 'Here upload \nside shot',
                    margin: EdgeInsets.only(top: 8),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }), //image picker
  Container(), //personal info
  Container(), //goals and life style
];

class ImagePickerContainer extends StatelessWidget {
  const ImagePickerContainer(
      {super.key,
      required this.width,
      required this.height,
      this.text,
      required this.icon,
      this.onTap,
      this.margin});

  final double width;
  final double height;
  final String? text;
  final EdgeInsets? margin;
  final Widget icon;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          padding: EdgeInsets.zero,
          borderType: BorderType.RRect,
          radius: Radius.circular(15),
          color: Color(0xff3B6790),
          strokeWidth: 1,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: Color(0xff3B6790).withValues(alpha: .2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff282828).withValues(alpha: .8)),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
