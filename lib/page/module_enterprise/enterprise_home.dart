import 'package:flutter/material.dart';

import 'abarbeitung/enterprise_details.dart';

///企业端首页
class EnterpriseHome extends StatefulWidget {
  const EnterpriseHome({Key? key}) : super(key: key);

  @override
  _EnterpriseHomeState createState() => _EnterpriseHomeState();
}

class _EnterpriseHomeState extends State<EnterpriseHome> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EnterpriseDetails(),
    );
  }
}

