<?php
	// ***********************
	// *** Basic settings  ***
	// ***********************

	putenv('SINGLE_USER_MODE=false');
	// Operate in single user mode, disables all functionality related to
	// multiple users and authentication. Enabling this assumes you have
	// your tt-rss directory protected by other means (e.g. http auth).

	putenv('SIMPLE_UPDATE_MODE=false');
	// Enables fallback update mode where tt-rss tries to update feeds in
	// background while tt-rss is open in your browser.
	// If you don't have a lot of feeds and don't want to or can't run
	// background processes while not running tt-rss, this method is generally
	// viable to keep your feeds up to date.
	// Still, there are more robust (and recommended) updating methods
	// available, you can read about them here: http://tt-rss.org/wiki/UpdatingFeeds

	// *****************************
	// *** Files and directories ***
	// *****************************

	putenv('PHP_EXECUTABLE=/usr/bin/php');
	// Path to PHP *COMMAND LINE* executable, used for various command-line tt-rss
	// programs and update daemon. Do not try to use CGI binary here, it won't work.
	// If you see HTTP headers being displayed while running tt-rss scripts,
	// then most probably you are using the CGI binary. If you are unsure what to
	// put in here, ask your hosting provider.

	putenv('LOCK_DIRECTORY=lock');
	// Directory for lockfiles, must be writable to the user you run
	// daemon process or cronjobs under.

	putenv('CACHE_DIR=cache');
	// Local cache directory for RSS feed content.

	putenv('ICONS_DIR=feed-icons');
	putenv('ICONS_URL=feed-icons');
	// Local and URL path to the directory, where feed favicons are stored.
	// Unless you really know what you're doing, please keep those relative
	// to tt-rss main directory.

	// **********************
	// *** Authentication ***
	// **********************

	// Please see PLUGINS below to configure various authentication modules.

	putenv('AUTH_AUTO_CREATE=false');
	// Allow authentication modules to auto-create users in tt-rss internal
	// database when authenticated successfully.

	putenv('AUTH_AUTO_LOGIN=false');
	// Automatically login user on remote or other kind of externally supplied
	// authentication, otherwise redirect to login form as normal.
	// If set to true, users won't be able to set application language
	// and settings profile.

	// *********************
	// *** Feed settings ***
	// *********************

	putenv('FORCE_ARTICLE_PURGE=0');
	// When this option is not 0, users ability to control feed purging
	// intervals is disabled and all articles (which are not starred)
	// older than this amount of days are purged.

	// **********************************
	// *** Cookies and login sessions ***
	// **********************************

	putenv('SESSION_COOKIE_LIFETIME=86400');
	// Default lifetime of a session (e.g. login) cookie. In seconds,
	// 0 means cookie will be deleted when browser closes.

	// ***************************************
	// *** Other settings (less important) ***
	// ***************************************

	putenv('CHECK_FOR_UPDATES=false');
	// Check for updates automatically if running Git version

	putenv('LOG_DESTINATION=sql');
	// Log destination to use. Possible values: sql (uses internal logging
	// you can read in Preferences -> System), syslog - logs to system log.
	// Setting this to blank uses PHP logging (usually to http server
	// error.log).

	// vim:ft=php
