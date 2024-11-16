bool isText(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if(!isRequired && (inputString == null ? true : inputString.isEmpty)){
    isInputStringValid = true;
  }
  if(inputString != null && inputString.isNotEmpty){
    const pattern = r'^[a-zA-Z]+$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }return isInputStringValid;
}