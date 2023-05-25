// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gooddelivary/constants/enums.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/features/profile/service/profile_service.dart';

class ProfileTitleChange extends StatefulWidget {
  final UserTitleType userTitleType;
  final String title;
  const ProfileTitleChange(
      {Key? key, required this.userTitleType, required this.title})
      : super(key: key);

  @override
  State<ProfileTitleChange> createState() => _ProfileTitleChangeState();
}

class _ProfileTitleChangeState extends State<ProfileTitleChange> {
  TextEditingController? _userTitleContoller;

  @override
  void initState() {
    super.initState();
    _userTitleContoller = TextEditingController(text: widget.title);
  }

  final ProfileService _profileService = ProfileService();
  final _changeUserDataFormKey = GlobalKey<FormState>();

  setChange() {
    _profileService.changeUserData(
        context: context,
        userTitleType: widget.userTitleType,
        title: _userTitleContoller!.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 42,
                    child: const Text(
                      'GoodDelivery',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.notifications_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
              key: _changeUserDataFormKey,
              child: TextFormField(
                validator: (val) {
                  if (widget.userTitleType == UserTitleType.email) {
                    bool isEmailValid = isValidEmail(val!);
                    if (isEmailValid) {
                      return null;
                    } else {
                      return "Check your email";
                    }
                  }
                  return null;
                },
                controller: _userTitleContoller,
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  if (_changeUserDataFormKey.currentState!.validate()) {
                    setChange();
                  }
                },
                child: const Text('Confirm'))
          ],
        ),
      ),
    );
  }
}
