import 'package:finances_manager/pages/add_account.dart';
import 'package:finances_manager/pages/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Router {
  static const homePage = 'app://';
  static const checkbookDetail = 'app://AddAccount';

  Widget _getPage(String url, dynamic params) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
      return WebViewPage(url, params: params);
    } else {
      switch (url) {
        case checkbookDetail:
          return AddAccountPage();
      }
    }
    return null;
  }

//
//  void push(BuildContext context, String url, dynamic params) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return _getPage(url, params);
//    }));
//  }

  Router.pushNoParams(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, null);
    }));
  }

  Router.push(BuildContext context, String url, dynamic params) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }
}