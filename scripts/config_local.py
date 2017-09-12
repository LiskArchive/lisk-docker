##########################################################################
#
# pgAdmin 4 - PostgreSQL Tools
#
# Copyright (C) 2013 - 2016, The pgAdmin Development Team
# This software is released under the PostgreSQL Licence
#
# config.py - Core application configuration settings
#
##########################################################################

from logging import *
import os

##########################################################################
# Log settings
##########################################################################

# Debug mode?
DEBUG = False

# Application log level - one of:
#   CRITICAL 50
#   ERROR    40
#   WARNING  30
#   SQL      25
#   INFO     20
#   DEBUG    10
#   NOTSET    0
CONSOLE_LOG_LEVEL = WARNING
FILE_LOG_LEVEL = INFO

# Log file name
LOG_FILE = '/dev/stdout'

##########################################################################
# Server settings
##########################################################################

# The server mode determines whether or not we're running on a web server
# requiring user authentication, or desktop mode which uses an automatic
# default login.
#
SERVER_MODE = os.environ['SERVER_MODE'].lower() in ("yes", "true", "1")

# This configuration otion allows the user to host the application on a LAN
# Default hosting is on localhost (DEFAULT_SERVER='localhost').
# To host pgAdmin4 over LAN set DEFAULT_SERVER='0.0.0.0' (or a specific
# adaptor address.
#
DEFAULT_SERVER = '0.0.0.0'

# The default port on which the app server will listen if not set in the
# environment by the runtime
DEFAULT_SERVER_PORT = int(os.environ['SERVER_PORT'])

# Should HTML be minified on the fly when not in debug mode?
MINIFY_HTML = True

##########################################################################
# Mail server settings
##########################################################################

# These settings are used when running in web server mode for confirming
# and resetting passwords etc.
MAIL_SERVER = os.environ['MAIL_SERVER']
MAIL_PORT = int(os.environ['MAIL_PORT'])
MAIL_USE_SSL = os.environ['MAIL_USE_SSL'].lower() in ("yes", "true", "1")
MAIL_USERNAME = os.environ['MAIL_USERNAME']
MAIL_PASSWORD = os.environ['MAIL_PASSWORD']

##########################################################################
# Upgrade checks
##########################################################################

# Check for new versions of the application?
UPGRADE_CHECK_ENABLED = False

# Where should we get the data from?
UPGRADE_CHECK_URL = 'https://www.pgadmin.org/versions.json'

DATA_DIR = '/data'
SQLITE_PATH = '/data/config/pgadmin4.db'
SESSION_DB_PATH = '/data/sessions'
STORAGE_DIR = '/data/storage'