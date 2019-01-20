## Developing for Zeeguu-Ecosystem

First of all, clone this repository by running:
```
git clone --recursive https://github.com/zeeguu-ecosystem/Lineup
```

Make sure to fork the repository which you want to update on your account.
Add your branch to the repository by running the following command inside the
desired repository:
```
git remote add <remote_name> https://github.com/<your_username>/Zeeguu-API
```

Example, for Zeeguu-API:
```
git remote add myremote https://github.com/alinbalutoiu/Zeeguu-API
```

You can check that everything is working by running ``git remote -v`` which will
print the tracked repositories:
```
root@zeguu:~/Lineup/Zeeguu-API# git remote -v
myremote        https://github.com/alinbalutoiu/Zeeguu-API (fetch)
myremote        https://github.com/alinbalutoiu/Zeeguu-API (push)
origin  https://github.com/zeeguu-ecosystem/Zeeguu-API (fetch)
origin  https://github.com/zeeguu-ecosystem/Zeeguu-API (push)
```

It's time to switch to the branch from your fork using:
```
git checkout -b myremote/master
```

You can now start working on your changes.

To push your changes, you first need to upload them on your repository by running:
```
git push myremote master
```
After that you can create a pull request under that repository on https://github.com/zeeguu-ecosystem

### Testing your changes

Make sure the MySQL database is running. You can run the script [run_mysql.sh](run_mysql.sh)
to make sure the database is running.

#### Zeeguu-API-Core

Create the base container image with the following command:
```
docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .
```

After that, use the script [rebuild_api_core.sh](rebuild_api_core.sh) to rebuild and
launch the docker container. You need to run the script after every change you are
doing to the code in either Zeeguu-Core or Zeeguu-API. Be sure to update the script
with valid API keys that you are using for testing.

*NOTE*: If you are planning to change the dependencies for the project, it is required
to rebuild the base container image prior to running the rebuild script.

#### Zeeguu-Web

Create the base container image with the following command:
```sh
docker build -t zeeguu-web -f docker-files/zeeguu-web/Dockerfile .
```

Use the script [rebuild_web.sh](rebuild_web.sh) to rebuild and launch the docker container.
You need to run this to test every new code change.

*NOTE*: If you are planning to change the dependencies for the project, it is required
to rebuild the base container image prior to running the rebuild script.

#### Test RSS feed

To quickly add a test RSS feed, run the script [add_test_rss_feed.sh](add_test_rss_feed.sh).
