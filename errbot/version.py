import os

# Just the current version of Errbot.
# It is used for deployment on pypi AND for version checking at plugin load time.
VERSION = os.getEnv('RELEASE_VERSION')  # leave it at 9.9.9 on master until it is branched to a version.
