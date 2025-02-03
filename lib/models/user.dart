//This file holds the user information related to filling out the form
//First name, Last name, Email, Email Confirmation, Telephone, DateTime, Number of Nights, Licence plate

class User {
  String? firstName;
  String? lastName;
  String? email;
  String? telephone;
  //Maybe a date time range for if user wants multiple nights
  DateTime? startDate;
  int? numberOfNights;
  String? licencePlate;

  //User Nights Remaining
  int? nightsRemaining = 15;

  User(
      this.firstName,
      this.lastName,
      this.email,
      this.telephone,
      this.startDate,
      this.numberOfNights,
      this.licencePlate,
      this.nightsRemaining);

//Display user information before sending form, ensure their details are correct
  @override
  String toString() => "";
}
