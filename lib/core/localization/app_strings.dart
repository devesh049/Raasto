import 'app_locale.dart';

/// Lightweight, type-safe localization.
///
/// Every user-facing string lives here as a getter so screens never hard-code
/// text. Hindi is the default reading experience for the pilot market; English
/// is fully supported. Add new strings as getters to keep compile-time safety.
class AppStrings {
  const AppStrings(this.locale);

  final AppLocale locale;

  bool get _hi => locale.isHindi;

  String _t(String hi, String en) => _hi ? hi : en;

  // ---------------------------------------------------------------------------
  // Brand & general
  // ---------------------------------------------------------------------------
  String get appName => 'Raasto';
  String get tagline => _t('हर सफ़र, आसान रास्ता', 'Har Safar, Aasaan Raasta');

  String get continueText => _t('आगे बढ़ें', 'Continue');
  String get next => _t('आगे', 'Next');
  String get skip => _t('छोड़ें', 'Skip');
  String get getStarted => _t('शुरू करें', 'Get Started');
  String get back => _t('पीछे', 'Back');
  String get cancel => _t('रद्द करें', 'Cancel');
  String get save => _t('सेव करें', 'Save');
  String get ok => _t('ठीक है', 'OK');
  String get tryAgain => _t('दोबारा कोशिश करें', 'Try Again');
  String get loading => _t('लोड हो रहा है...', 'Loading...');
  String get comingSoon => _t('जल्द आ रहा है', 'Coming soon');
  String get optional => _t('वैकल्पिक', 'Optional');
  String get edit => _t('बदलें', 'Edit');
  String get retry => _t('फिर कोशिश करें', 'Retry');

  // ---------------------------------------------------------------------------
  // Language selection
  // ---------------------------------------------------------------------------
  String get chooseLanguageTitle => _t('अपनी भाषा चुनें', 'Choose Your Language');
  String get chooseLanguageSubtitle =>
      _t('आप बाद में सेटिंग्स में भाषा बदल सकते हैं।', 'You can change the language later in Settings.');

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------
  String get onboarding1Title => _t('अपना सफ़र आसान बनाएं', 'Make Your Journey Easy');
  String get onboarding1Desc => _t(
        'अपने शहर या दूसरे शहर जाने के लिए आसानी से राइड खोजें।',
        'Find rides easily to travel within your city or to another city.',
      );

  String get onboarding2Title => _t('खाली वापस न आएं', 'Don\'t Return Empty');
  String get onboarding2Desc => _t(
        'ड्राइवर अपनी वापसी की यात्रा पर उपलब्ध सीटें शेयर करके अतिरिक्त कमाई कर सकते हैं।',
        'Drivers can share available seats on their return journey and earn extra.',
      );

  String get onboarding3Title => _t('सफ़र और सामान, दोनों आसान', 'Rides and Goods, Both Easy');
  String get onboarding3Desc => _t(
        'यात्री राइड बुक करें या अपना सामान भेजने के लिए उपयुक्त वाहन खोजें।',
        'Book a ride as a passenger or find a suitable vehicle to send your goods.',
      );

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------
  String get welcomeTitle => _t('रास्तो में आपका स्वागत है', 'Welcome to Raasto');
  String get enterMobile => _t('अपना मोबाइल नंबर डालें', 'Enter your mobile number');
  String get mobileNumber => _t('मोबाइल नंबर', 'Mobile Number');
  String get mobileHint => _t('10 अंकों का नंबर', '10-digit number');
  String get invalidMobile => _t('सही 10 अंकों का मोबाइल नंबर डालें।', 'Enter a valid 10-digit mobile number.');
  String get byContinuingPrefix => _t('आगे बढ़ने पर आप हमारी', 'By continuing you agree to our');
  String get terms => _t('शर्तें', 'Terms');
  String get and => _t('और', 'and');
  String get privacyPolicy => _t('गोपनीयता नीति', 'Privacy Policy');
  String get sendOtp => _t('OTP भेजें', 'Send OTP');

  // ---------------------------------------------------------------------------
  // OTP
  // ---------------------------------------------------------------------------
  String get verifyNumberTitle => _t('अपना नंबर वेरिफ़ाई करें', 'Verify Your Number');
  String otpSentTo(String number) => _t(
        'हमने $number पर OTP भेजा है।',
        'We have sent an OTP to $number.',
      );
  String get enterOtp => _t('6 अंकों का OTP डालें', 'Enter the 6-digit OTP');
  String get verify => _t('वेरिफ़ाई करें', 'Verify');
  String get resendOtp => _t('OTP दोबारा भेजें', 'Resend OTP');
  String resendIn(String seconds) => _t('$seconds सेकंड में दोबारा भेजें', 'Resend in $seconds s');
  String get changeNumber => _t('मोबाइल नंबर बदलें', 'Change mobile number');
  String get invalidOtp => _t('गलत OTP। दोबारा कोशिश करें।', 'Wrong OTP. Please try again.');
  String get otpSentAgain => _t('OTP दोबारा भेजा गया।', 'OTP sent again.');

  // ---------------------------------------------------------------------------
  // Profile setup
  // ---------------------------------------------------------------------------
  String get profileTitle => _t('अपनी प्रोफ़ाइल बनाएं', 'Create Your Profile');
  String get profileSubtitle => _t(
        'सिर्फ़ ज़रूरी जानकारी दें। आप बाकी विवरण बाद में जोड़ सकते हैं।',
        'Share only what is needed. You can add more details later.',
      );
  String get fullName => _t('पूरा नाम', 'Full Name');
  String get fullNameHint => _t('जैसे: राहुल शर्मा', 'e.g. Rahul Sharma');
  String get profilePhoto => _t('प्रोफ़ाइल फ़ोटो', 'Profile Photo');
  String get addPhoto => _t('फ़ोटो जोड़ें', 'Add Photo');
  String get changePhoto => _t('फ़ोटो बदलें', 'Change Photo');
  String get gender => _t('लिंग', 'Gender');
  String get genderMale => _t('पुरुष', 'Male');
  String get genderFemale => _t('महिला', 'Female');
  String get genderOther => _t('अन्य', 'Other');
  String get genderPreferNot => _t('बताना नहीं चाहते', 'Prefer not to say');
  String get email => _t('ईमेल', 'Email');
  String get emailOptionalHint => _t('वैकल्पिक', 'Optional');
  String get nameRequired => _t('कृपया अपना नाम डालें।', 'Please enter your name.');
  String get saveContinue => _t('सेव करें और आगे बढ़ें', 'Save and Continue');

  // ---------------------------------------------------------------------------
  // Home
  // ---------------------------------------------------------------------------
  String greeting(String name) => _t('नमस्ते, $name!', 'Namaste, $name!');
  String get whereToGo => _t('कहाँ जाना है?', 'Where do you want to go?');
  String get from => _t('कहाँ से?', 'From');
  String get to => _t('कहाँ तक?', 'To');
  String get journeyDate => _t('यात्रा की तारीख़', 'Journey Date');
  String get passengers => _t('यात्री', 'Passengers');
  String get vehicleType => _t('वाहन का प्रकार', 'Vehicle Type');
  String get anyVehicle => _t('कोई भी वाहन', 'Any Vehicle');
  String get findRides => _t('राइड खोजें', 'Find Rides');
  String get swapLocations => _t('जगह बदलें', 'Swap locations');
  String get enterBothLocations => _t(
        'कृपया "कहाँ से" और "कहाँ तक" दोनों भरें।',
        'Please enter both From and To.',
      );

  String get goodsTransport => _t('सामान ट्रांसपोर्ट', 'Goods Transport');
  String get sendGoods => _t('अपना सामान भेजें', 'Send your goods');
  String get findVehicle => _t('वाहन खोजें', 'Find Vehicle');

  String get becomeDriver => _t('ड्राइवर बनें', 'Become a Driver');
  String get earnBySharing => _t('राइड शेयर करके कमाई करें', 'Earn by sharing rides');
  String get startDriving => _t('ड्राइविंग शुरू करें', 'Start Driving');

  String get returnRideQuestion => _t('वापसी की राइड चाहिए?', 'Need a return ride?');
  String get returnRideDesc =>
      _t('उपलब्ध रिटर्न ट्रिप यहाँ भी खोजें।', 'Find available return trips here too.');
  String get exploreReturn => _t('रिटर्न राइड देखें', 'Explore Return Rides');

  // Bottom navigation
  String get navHome => _t('होम', 'Home');
  String get navBookings => _t('मेरी बुकिंग', 'My Bookings');
  String get navNotifications => _t('सूचनाएँ', 'Notifications');
  String get navProfile => _t('प्रोफ़ाइल', 'Profile');

  // ---------------------------------------------------------------------------
  // Empty / error / offline states
  // ---------------------------------------------------------------------------
  String get noInternet => _t('इंटरनेट कनेक्शन नहीं है।', 'No internet connection.');
  String get noInternetDesc =>
      _t('कृपया अपना कनेक्शन जाँचें और दोबारा कोशिश करें।', 'Please check your connection and try again.');
  String get somethingWrong => _t('कुछ गड़बड़ हो गई।', 'Something went wrong.');
  String get somethingWrongDesc =>
      _t('कृपया थोड़ी देर बाद दोबारा कोशिश करें।', 'Please try again in a moment.');

  String get noRides => _t('कोई राइड नहीं मिली', 'No rides found');
  String get noRidesDesc =>
      _t('इस रूट पर अभी कोई राइड उपलब्ध नहीं है।', 'No rides available on this route right now.');
  String get noBookings => _t('कोई बुकिंग नहीं', 'No bookings yet');
  String get noBookingsDesc =>
      _t('जब आप राइड बुक करेंगे, वे यहाँ दिखेंगी।', 'Your booked rides will appear here.');
  String get noNotifications => _t('कोई सूचना नहीं', 'No notifications');
  String get noNotificationsDesc =>
      _t('बुकिंग और सेफ़्टी अपडेट यहाँ दिखेंगे।', 'Booking and safety updates will appear here.');

  // ---------------------------------------------------------------------------
  // Profile tab
  // ---------------------------------------------------------------------------
  String get accountInfo => _t('अकाउंट जानकारी', 'Account Information');
  String get passengerAccount => _t('यात्री अकाउंट', 'Passenger account');
  String get logout => _t('लॉगआउट', 'Logout');
  String get logoutConfirm => _t('क्या आप लॉगआउट करना चाहते हैं?', 'Do you want to log out?');
  String get language => _t('भाषा', 'Language');

  // ---------------------------------------------------------------------------
  // Bookings tabs
  // ---------------------------------------------------------------------------
  String get tabUpcoming => _t('आने वाली', 'Upcoming');
  String get tabPending => _t('इंतज़ार में', 'Pending');
  String get tabCompleted => _t('पूरी हुई', 'Completed');
  String get tabCancelled => _t('रद्द', 'Cancelled');

  // ---------------------------------------------------------------------------
  // Profile menu
  // ---------------------------------------------------------------------------
  String get editProfile => _t('प्रोफ़ाइल बदलें', 'Edit Profile');
  String get myTrips => _t('मेरी ट्रिप', 'My Trips');
  String get myVehicles => _t('मेरे वाहन', 'My Vehicles');
  String get savedLocations => _t('सेव किए स्थान', 'Saved Locations');
  String get emergencyContacts => _t('आपातकालीन संपर्क', 'Emergency Contacts');
  String get payments => _t('भुगतान', 'Payments');
  String get helpSupport => _t('सहायता और समर्थन', 'Help & Support');
  String get termsTitle => _t('नियम और शर्तें', 'Terms & Conditions');
  String get privacyTitle => _t('गोपनीयता नीति', 'Privacy Policy');
  String get safety => _t('सुरक्षा', 'Safety');
  String get deleteAccount => _t('अकाउंट हटाएँ', 'Delete Account');
  String get appVersion => _t('ऐप संस्करण', 'App Version');
  String get verified => _t('वेरिफ़ाइड', 'Verified');
  String get notVerifiedYet => _t('अभी वेरिफ़ाइड नहीं', 'Not verified yet');

  // ---------------------------------------------------------------------------
  // Search results
  // ---------------------------------------------------------------------------
  String get availableRides => _t('उपलब्ध राइड', 'Available Rides');
  String ridesFound(int n) => _t('$n राइड मिलीं', '$n rides found');
  String get sortBy => _t('क्रमबद्ध करें', 'Sort by');
  String get filters => _t('फ़िल्टर', 'Filters');
  String get sortEarliest => _t('सबसे पहले', 'Earliest');
  String get sortCheapest => _t('सबसे सस्ता', 'Cheapest');
  String get sortNearest => _t('सबसे नज़दीक', 'Nearest');
  String get seatsLeft => _t('सीटें शेष', 'seats left');
  String seatsAvailable(int n) => _t('$n सीटें उपलब्ध', '$n seats available');
  String get departure => _t('प्रस्थान', 'Departure');
  String get arrival => _t('आगमन', 'Arrival');
  String get duration => _t('अवधि', 'Duration');
  String get perSeat => _t('प्रति सीट', 'per seat');
  String get bookNow => _t('अभी बुक करें', 'Book Now');
  String get viewDetails => _t('विवरण देखें', 'View Details');
  String get ac => _t('AC', 'AC');
  String get nonAc => _t('नॉन-AC', 'Non-AC');

  // ---------------------------------------------------------------------------
  // Ride details
  // ---------------------------------------------------------------------------
  String get rideDetails => _t('राइड विवरण', 'Ride Details');
  String get driverInfo => _t('ड्राइवर', 'Driver');
  String get vehicleInfo => _t('वाहन', 'Vehicle');
  String get tripsLabel => _t('ट्रिप', 'Trips');
  String get reviewsLabel => _t('रिव्यू', 'reviews');
  String get amenities => _t('सुविधाएँ', 'Amenities');
  String get pickupPoint => _t('पिकअप पॉइंट', 'Pickup Point');
  String get dropPoint => _t('ड्रॉप पॉइंट', 'Drop Point');
  String get routeLabel => _t('रूट', 'Route');
  String get call => _t('कॉल करें', 'Call');
  String get message => _t('मैसेज', 'Message');

  // ---------------------------------------------------------------------------
  // Booking
  // ---------------------------------------------------------------------------
  String get bookingSummary => _t('बुकिंग सारांश', 'Booking Summary');
  String get fareBreakdown => _t('किराया विवरण', 'Fare Breakdown');
  String get baseFare => _t('आधार किराया', 'Base fare');
  String get seats => _t('सीटें', 'Seats');
  String get serviceFee => _t('सेवा शुल्क', 'Service fee');
  String get taxes => _t('कर', 'Taxes');
  String get totalPayable => _t('कुल देय', 'Total payable');
  String get paymentMethod => _t('भुगतान का तरीक़ा', 'Payment Method');
  String get payCash => _t('नक़द भुगतान', 'Cash');
  String get payCashDesc => _t('ड्राइवर को सीधे भुगतान करें', 'Pay the driver directly');
  String get payOnline => _t('ऑनलाइन भुगतान', 'Online');
  String get payOnlineDesc => _t('UPI, कार्ड या वॉलेट', 'UPI, card or wallet');
  String get confirmBooking => _t('बुकिंग पक्की करें', 'Confirm Booking');
  String get cancelAnytime => _t('पिकअप से 30 मिनट पहले तक मुफ़्त रद्द करें।', 'Free cancellation up to 30 minutes before pickup.');

  // ---------------------------------------------------------------------------
  // Booking success
  // ---------------------------------------------------------------------------
  String get bookingConfirmed => _t('बुकिंग पक्की हो गई!', 'Booking Confirmed!');
  String get bookingConfirmedDesc => _t(
        'आपकी राइड बुक हो गई है। ड्राइवर की जानकारी भेज दी गई है।',
        'Your ride is booked. Driver details have been shared.',
      );
  String get bookingId => _t('बुकिंग आईडी', 'Booking ID');
  String get viewTicket => _t('टिकट देखें', 'View Ticket');
  String get backToHome => _t('होम पर जाएँ', 'Back to Home');
  String get shareTicket => _t('टिकट शेयर करें', 'Share Ticket');
  String get seat => _t('सीट', 'Seat');

  // ---------------------------------------------------------------------------
  // My bookings
  // ---------------------------------------------------------------------------
  String get trackRide => _t('राइड ट्रैक करें', 'Track Ride');
  String get cancelBooking => _t('बुकिंग रद्द करें', 'Cancel Booking');
  String get rateRide => _t('रेटिंग दें', 'Rate Ride');
  String get pendingPayment => _t('भुगतान बाकी', 'Payment pending');
  String get confirmCancelTitle => _t('बुकिंग रद्द करें?', 'Cancel this booking?');
  String get confirmCancelDesc => _t(
        'यह बुकिंग हटा दी जाएगी। यह वापस नहीं आएगी।',
        'This booking will be removed. This cannot be undone.',
      );
  String get yesCancel => _t('हाँ, रद्द करें', 'Yes, cancel');
  String get keepBooking => _t('रहने दें', 'Keep it');
  String get bookingCancelledMsg => _t('बुकिंग रद्द कर दी गई।', 'Booking cancelled.');
  String get noUpcomingDesc =>
      _t('जब आप कोई राइड बुक करेंगे, वह यहाँ दिखेगी।', 'Your booked rides will appear here.');
  String get noPendingDesc =>
      _t('नक़द भुगतान वाली बुकिंग यहाँ दिखेंगी।', 'Cash-payment bookings will appear here.');
  String get noCompletedDesc =>
      _t('पूरी हुई यात्राएँ यहाँ दिखेंगी।', 'Your finished trips will appear here.');
  String get noCancelledDesc =>
      _t('रद्द की गई बुकिंग यहाँ दिखेंगी।', 'Cancelled bookings will appear here.');

  // ---------------------------------------------------------------------------
  // Goods transport
  // ---------------------------------------------------------------------------
  String get goodsDetails => _t('सामान की जानकारी', 'Goods Details');
  String get goodsDetailsDesc => _t(
        'कुछ जानकारी दें, हम उपयुक्त वाहन और भाव दिखाएँगे।',
        'Share a few details and we will show suitable vehicles and prices.',
      );
  String get goodsType => _t('सामान का प्रकार', 'Goods Type');
  String get goodsHousehold => _t('घरेलू सामान', 'Household');
  String get goodsElectronics => _t('इलेक्ट्रॉनिक्स', 'Electronics');
  String get goodsFurniture => _t('फर्नीचर', 'Furniture');
  String get goodsDocuments => _t('दस्तावेज़', 'Documents');
  String get goodsAgriculture => _t('कृषि उपज', 'Agriculture');
  String get goodsOther => _t('अन्य', 'Other');
  String get approxWeight => _t('अनुमानित वज़न', 'Approx. Weight');
  String get weightUnit => _t('किलो', 'kg');
  String get chooseVehicle => _t('वाहन चुनें', 'Choose Vehicle');
  String get getQuotes => _t('कोटेशन देखें', 'Get Quotes');
  String get quotesTitle => _t('उपलब्ध वाहन', 'Available Vehicles');
  String quotesFound(int n) => _t('$n वाहन उपलब्ध', '$n vehicles available');
  String get capacityLabel => _t('क्षमता', 'Capacity');
  String get bookVehicle => _t('वाहन बुक करें', 'Book Vehicle');
  String get transporterInfo => _t('ट्रांसपोर्टर', 'Transporter');
  String get etaPickup => _t('पिकअप अनुमानित', 'Estimated pickup');
  String get goodsBooked => _t('सामान बुक हो गया!', 'Goods Booked!');
  String get goodsBookedDesc => _t(
        'ट्रांसपोर्टर को आपकी जानकारी भेज दी गई है।',
        'Your details have been shared with the transporter.',
      );
  String get goodsBookingId => _t('बुकिंग आईडी', 'Booking ID');
  String get noQuotes => _t('कोई वाहन नहीं मिला', 'No vehicles found');
  String get noQuotesDesc =>
      _t('इस रूट पर अभी कोई वाहन उपलब्ध नहीं है।', 'No vehicles available on this route right now.');

  // ---------------------------------------------------------------------------
  // Driver mode
  // ---------------------------------------------------------------------------
  String get driverMode => _t('ड्राइवर मोड', 'Driver Mode');
  String get publishRide => _t('राइड पब्लिश करें', 'Publish Ride');
  String get publishRideDesc => _t(
        'अपनी खाली सीटें शेयर करें और कमाई करें।',
        'Share your empty seats and earn extra.',
      );
  String get myPublishedRides => _t('मेरी पब्लिश की राइड', 'My Published Rides');
  String get seatsOffered => _t('उपलब्ध सीटें', 'Seats offered');
  String get departureTime => _t('प्रस्थान समय', 'Departure Time');
  String get publish => _t('पब्लिश करें', 'Publish');
  String get ridePublished => _t('राइड पब्लिश हो गई!', 'Ride published!');
  String get noPublishedRides => _t('अभी कोई राइड नहीं', 'No rides published yet');
  String get noPublishedRidesDesc =>
      _t('आपकी पब्लिश की गई राइड यहाँ दिखेंगी।', 'Rides you publish will appear here.');
  String get todayEarnings => _t('आज की कमाई', 'Today\'s earnings');
  String get todayTrips => _t('आज की ट्रिप', 'Trips today');
  String get requiredField => _t('यह फ़ील्ड ज़रूरी है।', 'This field is required.');
  String get removeRide => _t('हटाएँ', 'Remove');
  String get rideRemoved => _t('राइड हटा दी गई।', 'Ride removed.');
  String get vehicleDetails => _t('वाहन विवरण', 'Vehicle details');

  // ---------------------------------------------------------------------------
  // Trip tracking
  // ---------------------------------------------------------------------------
  String get tripTracking => _t('ट्रिप ट्रैकिंग', 'Trip Tracking');
  String get driverOnTheWay => _t('ड्राइवर रास्ते में है', 'Driver is on the way');
  String get arrivingIn => _t('पहुँचने में', 'Arriving in');
  String get minutesShort => _t('मिनट', 'min');
  String get shareTrip => _t('ट्रिप शेयर करें', 'Share Trip');
  String get liveLocation => _t('लाइव लोकेशन', 'Live Location');
  String get tripOtp => _t('ट्रिप OTP', 'Trip OTP');
  String get tripOtpDesc => _t('ड्राइवर को यह OTP बताएँ।', 'Share this OTP with the driver.');
  String get sos => _t('SOS', 'SOS');

  // ---------------------------------------------------------------------------
  // Ratings
  // ---------------------------------------------------------------------------
  String get rateYourRide => _t('अपनी राइड को रेट करें', 'Rate Your Ride');
  String get rateDesc => _t('ड्राइवर के साथ अनुभव कैसा रहा?', 'How was your experience with the driver?');
  String get writeReview => _t('रिव्यू लिखें (वैकल्पिक)', 'Write a review (optional)');
  String get submitRating => _t('रेटिंग सबमिट करें', 'Submit Rating');
  String get thanksRating => _t('रेटिंग के लिए धन्यवाद!', 'Thanks for your rating!');
  String get ratingPoor => _t('खराब', 'Poor');
  String get ratingFair => _t('ठीक-ठाक', 'Fair');
  String get ratingGood => _t('अच्छा', 'Good');
  String get ratingGreat => _t('बहुत अच्छा', 'Great');
  String get ratingExcellent => _t('शानदार', 'Excellent');
}
