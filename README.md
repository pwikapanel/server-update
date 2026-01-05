
<!-- vim: set foldmethod=marker fmr=###,--- :-->

*Updated 5 January, 2026*

![Pwika: SVG-based websites built in Adobe Illustrator][logo]

[logo]: http://files.pwika.com/github/github_banner.png "Pwika: SVG-based websites built in Adobe Illustrator"

<h3>Releasing a New Version of Pwika Cloud</h3>

See [issues](../../issues) for tasks specific to the current update.

### Updating Servers
<!----->

</details><hr><details name="only"><summary>1. Database & Server Backups</summary>

### 1. Database & Server Backups

SSH to the server, then:
```
cd /opt
ls /home
```
- [delete](https://github.com/pwikapanel/site-admin) any unused websites
- update `/opt/sitelist.txt` with **project folders from home directory** (not URL's):
- [back up](https://github.com/pwikapanel/site-admin) remaining websites
- make a cloud backup at [Linode/Akamai](https://cloud.linode.com/linodes).
```
cat version.txt
vi sitelist.txt
```
---

</details><details name="only"><summary>2. Update the Pwika Servers</summary>

### 2. Update the Pwika Servers

First, update the **server software**
```
apt update -y
apt dist-upgrade -y
```

**Check issues for other updates**

Check the `/opt/sitelist.txt` (it should be correct after backups):
```
ls /home && cd /opt
```
```
vi sitelist.txt
```
Clone the **git repository**:
```
cd /opt
rm -rf cloud-update
git clone ssh://git@github.com/pwikapanel/cloud-update.git
chmod 777 cloud-update/*.sh
```
To install a beta release:
```
# replace stable with beta in line 9
vi cloud-update/update.sh
```
Run the update script:
```
source cloud-update/update.sh
```
```
# update to new version
vi version.txt
```
---

</details><details name="only"><summary>3. Individual Website Updates</summary>

### 3. Individual Website Updates

Some updates require manual intervention for each site.

Look at the [issues][li] for **⚠️ updates for version 2.3.5** (for example)

Update websites accordingly.

[li]: https://github.com/pwikapanel/cloud-update/issues

---

</details><hr><details name="only"><summary>pre-installation: verifying Pwika Cloud</summary><br>

On the **Pwika Cloud development server**:

#### Check for Migrations

```
cd /home/ # any site
workon djangoEnv
./manage.py makemigrations
```
If there are migrations, migrate:
```
./manage.py migrate
```
If there were migrations, add to git and commit.

----
#### Script Minification

In the `templates` directory:
- full scripts with commentes take the form `filename_max.ext`
- minified versions take the form `filename_min.ext`

```
cd /opt/cloud/svija/templates/svija
ls -t */*
```
Minify any files that have been modified since the [last release](https://github.com/pwikapanel/cloud/releases) using the following tools:
- [toptal.com/css](https://www.toptal.com/developers/cssminifier)
- [toptal.com/html](https://www.toptal.com/developers/html-minifier)
- [toptal.com/javascript](https://www.toptal.com/developers/javascript-minifier)

Follow these steps:
1. commit any changes
2. copy the pages from the repository using Github's copy icon
3. paste into the minifier & minify
4. paste into the new version in Terminal

Update the main template:
```
vi svija.html
# :%s/_max/_min/g
```
---
#### Commit and Merge

In Pwika Cloud, check for unsaved changes and commit:
```
cd /opt/cloud
git status
```
Check out the **destination branch** and merge ([list of commits](https://github.com/pwikapanel/cloud/commits/beta)):
```
git checkout stable
git merge beta --no-ff
```
Push the new version:
```
git push origin stable
```
---
#### Update the Changelog

Copy info from/to:

- [github.com/pwikapanel/cloud/commits/stable](https://github.com/pwikapanel/cloud/commits/stable)    
- [tech.pwika.com/cloud/changelog](https://tech.pwika.com/programs/cloud/changelog)   

---
#### Create Installable Version

Create an **installable version** so that will be available in case of future compatibility problems:

Run the tarball creation script (automatically commits itself to Github):
```
cd /opt/cloud
./save_tar.sh
```
---
#### A New Github Release

On Github, create a [new release](https://github.com/pwikapanel/cloud/releases) from the **stable branch**.

- use the current version number for the tag (2.2.7)
- choose target **Master**
- use the month & year for the title (October 2021)
- if there is more than one release in a month, append -1, -2 etc. to all releases for the month
- use the [commit list](https://github.com/pwikapanel/cloud/commits/stable) for the description

---

</details><details name="only"><summary>post-installation: creating a new Beta version</summary><br>

On the **Pwika Cloud development server**:

#### 1. Check Out Beta Branch & Increment Version

Check out the beta branch:
```
git checkout beta 
git merge stable --no-ff -m "new version"
git push -u
```
Increment the version number:
```
cd /opt/cloud
grep -rI 2.3.4 *
```
```
# :windo %s/2.2.6/2.2.7/g
vi -O \
django_svija.egg-info/PKG-INFO \
save_tar.sh \
setup.py \
svija/views/__init__.py \
svija/templates/admin/base_site.html \
svija/static/admin/js/fetch-remote.js
```
---
#### 2. update GSAP

Go to [GSAP's installation page](https://gsap.com/docs/v3/Installation/)
- click on **Grab the files** then **Get GSAP**
- copy the contents of `minified/gsap.min.js` and paste into the following file
```
cd /opt/cloud
vi svija/static/svija/js/gsap.min.js
```
---
#### 3. Un-minify Scripts & Commit

```
cd /opt/cloud
vi svija/templates/svija/svija.html # replace _min with _max
```
```
git commit -m "Beta ready for development" -a && git push -u  
```
---

</details>

