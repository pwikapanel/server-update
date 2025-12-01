
<!-- vim: set foldmethod=marker fmr=###,--- :-->

*Updated 1 December, 2025*

![Pwika: SVG-based websites built in Adobe Illustrator][logo]

[logo]: http://files.pwika.com/github/github-logo.jpg "Pwika: SVG-based websites built in Adobe Illustrator"

*to clean up before making public:*
- references to google sheets on this page (search for `oogle`)


### Releasing a New Version of Pwika Cloud

Change to [detailed version](detailed-version.md) (potentially out of date). See [issues](../../issues) for tasks specific to the current update.

---

### Preparation
<!----->

<details><summary>1. Database & Server Backups</summary>

#### 1. Database & Server Backups

- SSH to the server
```
ls /home
```
- [delete][du] any unused websites
- update `/opt/sitelist.txt` with **project folders** (not URL's):
```
vi /opt/sitelist.txt
```
Verify that `.bashrc` has been updated:
```
,rc
```
- type `,bu` then `enter` to run the backup script  
  (see [site-management](https://github.com/svijasvg/site-mgmt/blob/beta/backup.md) for more information)

[du]: https://github.com/svijasvg/site-mgmt/blob/beta/delete.md

Make a cloud backup at [Linode/Akamai](https://cloud.linode.com/linodes).

---

</details><details><summary>2. Pwika Cloud: Check for Migrations, Commit & Merge</summary>

#### 2. Pwika Cloud: Check for Migrations, Commit & Merge

Back on the **dev server**, do any final migrations:
```
cd /home/svija210901
workon djangoEnv
./manage.py makemigrations
```
If there are migrations, migrate:
```
./manage.py migrate
```
---
</details><details><summary>3. Script Minification</summary>

#### 3. Script Minification

In the `templates` directory:
- commented scripts take the form `filename_max.ext`
- minified versions take the form `filename_min.ext`

```
cd /opt/cloud/svija/templates/svija
ls -t */*
```
Minify any files that have been modified since the last release using the following tools:
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
</details><details><summary>4. Commit and Push</summary>

#### 4. Commit and Push

In Pwika Cloud, check for unsaved changes and commit:
```
cd /opt/cloud
git status
```
Check out the **destination branch** and merge ([list of commits](https://github.com/svijasvg/cloud/commits/beta)):
```
git checkout master
git merge beta --no-ff
```
Push the new version:
```
git push origin master
```
---
</details><details><summary>5. Update the Changelog</summary>

#### 5. Update the Changelog

Copy info from/to:

- [github.com/svijasvg/cloud/commits/master](https://github.com/svijasvg/cloud/commits/master)    
- [tech.pwika.com/cloud/changelog](https://tech.pwika.com/programs/cloud/changelog)   

---
</details><details><summary>6. Pwika Cloud: Create Installable Version</summary>

#### 6. Pwika Cloud: Create Installable Version

Create an **installable version** so that will be available in case of future compatibility problems:

Run the tarball creation script (automatically commits itself to Github):
```
cd /opt/cloud
./save_tar.sh
```
---
</details><details><summary>7. A New Github Release</summary>

#### 7. A New Github Release

On Github, create a [new release](https://github.com/svijasvg/cloud/releases) from the **master branch**.

- use the current version number for the tag (2.2.7)
- choose target **Master**
- use the month & year for the title (October 2021)
- if there is more than one release in a month, append -1, -2 etc. to all releases for the month
- use the [commit list](https://github.com/svijasvg/cloud/commits/master) for the description

---
</details>

### Updating Servers
<!----->
<details><summary>1. Update the Pwika Servers</summary>

#### 1. Update the Pwika Servers

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
git clone ssh://git@github.com/svijasvg/cloud-update.git
chmod 777 cloud-update/*.sh
```
To install a beta release:
```
# replace master with beta in line 9
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
</details><details><summary>2. Individual Website Updates</summary>

#### 2. Individual Website Updates

Some updates require manual intervention for each site.

Look at the [issues][li] for **⚠️ updates for version 2.3.5** (for example)

Update websites accordingly.

[li]: https://github.com/svijasvg/cloud-update/issues

---

</details>

### A New Beta Version
<!----->
<details><summary>1. Check Out Beta Branch & Increment Version</summary>

#### 1. Check Out Beta Branch & Increment Version

Check out the beta branch:
```
git checkout beta 
git merge master --no-ff -m "new version"
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
</details><details><summary>2. update GSAP</summary>

#### 2. update GSAP

Go to [GSAP's installation page](https://gsap.com/docs/v3/Installation/)
- click on **Grab the files** then **Get GSAP**
- copy the contents of `minified/gsap.min.js` and paste into the following file
```
cd /opt/cloud
vi svija/static/svija/js/gsap.min.js
```
---
</details><details><summary>3. Un-minify Scripts & Commit</summary>

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

