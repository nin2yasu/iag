const express = require('express');
var router = express.Router();

// Handle GET request to /profile
router.get('/', function(req, res, _next) {
  console.log("START profile GET Function");
  // If session is unauthenticated, redirect to user login
  if (!req.session.authenticated) {
    req.session.afterlogin = "profile";
    res.redirect('/userlogin');
  } else { // user is authenticated

    var userJson = req.session.user;

    // Display Profile page
    res.render('profile', {
      title: 'User Profile',
      username: userJson.userName,
      email: userJson.emails[0].value,
      mobile: userJson.phoneNumbers[0].value,
    });
  }
});

module.exports = router;
