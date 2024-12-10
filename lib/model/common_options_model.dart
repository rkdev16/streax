

import 'dart:ui';

class OptionModel{
  String title;
  VoidCallback action;

  OptionModel(this.title,this.action);
}



class CommonDeleteModel{
  String title;
  String delete;
  VoidCallback action;

  CommonDeleteModel(this.title,this.action,this.delete);
}