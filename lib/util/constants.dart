
//  https://api.github.com/users/JakeWharton/repos?page=1&per_page=30
  import 'dart:ui';

import 'package:flutter/material.dart';

// var base_url="https://api.github.com/users/JakeWharton/repos";
var base_url="https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=";

// Sehwag&gpslimit=10
var titlestyle=TextStyle(
    color: Colors.black
    ,fontSize: 17 ,fontFamily: "Castoro"  );
var childtyle=TextStyle(
    color: Colors.black45
    ,fontSize: 16 ,fontFamily: "Castoro" ,decoration: TextDecoration.underline,  );
var othertyle=TextStyle(
    color: Colors.black45
    ,fontSize: 16 ,fontFamily: "Castoro"   );