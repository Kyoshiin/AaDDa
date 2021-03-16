class UserModel {
  String userID;
  String userName;
  String userEmail;
  String userPic;
  String userAbout;
  List contactList = [];

  UserModel(
      {this.userID,
      this.userName,
      this.userEmail,
      this.userPic,
      this.userAbout,
      this.contactList});
}
