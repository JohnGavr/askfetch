<!-- Badges -->
[![License][license-shield]][license-url]
[![Repo size][repo-size-shield]][repo-size-url]
[![Contributors][contributors-shield]][contributors-url]
[![Commits activity][commits-activity-shield]][commits-activity-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/JohnGavr/askfetch">
    <img src="https://github.com/JohnGavr/askfetch/raw/master/documentation/askfetch_logo.png" alt="Logo" width="500" height="120">
  </a>

  <h3 align="center">Askfetch.sh</h3>

  <p align="center">
    An awesome utility to get system info in a pretty way.
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/JohnGavr/askfetch/">View Demo</a>
    ·
    <a href="https://github.com/JohnGavr/askfetch/issues">Report Bug</a>
    ·
    <a href="https://github.com/JohnGavr/askfetch/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [English](#askfetch---system-information)
  * [About the Project](#about-the-project)
    * [Built With](#built-with)
  * [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
    * [Installation](#installation)
    * [Compatible distributions](#compatible-distributions)
  * [Usage](#usage)
  * [Roadmap](#roadmap)
  * [Contributing](#contributing)
  * [License](#license)
  * [Contact](#contact)
  * [Acknowledgements](#acknowledgements)
* [Ελληνικά](#askfetch---πληροφορίες-συστήματος)
  * [Σχετικά με το πρότζεκτ](#σχετικά-με-το-πρότζεκτ)
    * [Στοίβα τεχνολογιών](#στοίβα-τεχνολογιών)
  * [Βασικές οδηγίες](#βασικές-οδηγίες)
    * [Απαιτούμενα](#απαιτούμενα)
    * [Εγκατάσταση](#εγκατάσταση)
    * [Συμβατές διανομές](#συμβατές-διανομές)
  * [Χρήση](#χρήση)
  * [Επόμενα βήματα](#επόμενα-βήματα)
  * [Πώς να συμβάλλετε](#πώς-να-συμβάλλετε)
  * [Άδεια χρήσης](#άδεια-χρήσης)
  * [Επικοινωνία](#επικοινωνία)
  * [Ευχαριστίες](#ευχαριστίες)

# askfetch - System information

## About the project

A system information bash script inspired by screenfetch and neofetch.

[εικόνα εδώ]

### Built with
This script is developed in bash 5.0.7(1).

## Getting Started

### Prerequisites
In order to use `askfetch`, the following dependencies are required:
* gettext
* ... [TO-DO: list all non standard dependencies]
### Installation
Installation includes getting askfetch source code from this repository, until this script is in stable state and packaged for different distributions. Specifically:

1. First, clone askfetch source code:
```bash
git clone -b master https://github.com/JohnGavr/askfetch && cd askfetch
```
2. Then execute askfetch.sh with required parameters:
```bash
bash ./askfetch.sh
```
### Compatible distributions
Askfetch is compatible with the following distribution list (constantly updated, to be moved in separate text file):

* Systemd compatible distributions that support /etc/os-release (more info about this file [here](http://0pointer.de/blog/projects/os-release.html))

## Usage
```bash
Askfetch.sh system information tool.

 Options:
  -l,	  Script locale (e.g. el,en). Default is en.
  -d, 	Distribution logo. Default is current installed distribution.
  -h, 	Display this help and exit
"
```

### Distribution logo `-d <distro_id>`
For example ./askfetch.sh -d ubuntu forces ubuntu.txt logo usage.
### Interface locale `-l <locale_id>` 
For example:
* Greek: ./askfetch.sh -l el
* English: ./askfetch.sh -l en

By default, english locale is used for script prompts.

*Information about gettext usage found [here](https://www.linuxjournal.com/content/internationalizing-those-bash-scripts)*


## Distribution logos structure
Distribution logos that are used by askfetch are stored in `./logos` and have specific format. They are ASCII `.txt` files as the following one:

### manjaro.txt
```
label_color: \e[0m\e[1;32m
logo:
\e[0m\e[1;32m
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ████████            ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████
```

`label_color:` is an 8-bit color field. More information [here](https://misc.flogisoft.com/bash/tip_colors_and_formatting)

`logo` field includes the logo in ascii character format with color codes (non printable characters) when needed.

Logo files follow a certain naming convention: [distro_id].txt. In order to create one logo file for your distribution please use the name returned by the following bash command:
```bash
echo $(cat /etc/os-release | grep "ID=" | cut -d '=' -f2).txt
```

## Roadmap
Head to open [issues](https://github.com/JohnGavr/askfetch/issues) for a list of proposed features (and known issues).

## Contributing
Consult the [contribution guide](https://github.com/JohnGavr/askfetch/CONTRIBUTING.md) for contribution directions regarding askfetch.

## License
Distributed under the [ΑΔΕΙΑ ΧΡΉΣΗς ΕΔΏ]. See LICENSE for more information.

## Contact
For any issue/proposal regarding `askfetch` contact contributors either through this repo's issue page or through the corresponding thread at [Linux User GR](https://linux-user.gr/t/askfetch-plhrofories-systhmatos/) (Greek users only)

## Acknowledgements
* [Linux User GR](https://linux-user.gr/) for the support and constructive discussion during askfetch development.
* screenfetch
* neofetch

# askfetch - Πληροφορίες Συστήματος

## Σχετικά με το πρότζεκτ

Ένα bash script εμπνευσμένο από τα screenfetch και neofetch.

[εικόνα εδώ]

### Στοίβα τεχνολογιών
Το συγκεκριμένο script έχει γραφτεί σε bash 5.0.7(1).

## Βασικές οδηγίες

### Απαιτούμενα
Τα απαιτούμενα για την εκτέλεση του `askfetch` είναι:
* gettext
* ...άλλα
### Εγκατάσταση
Η διαδικασία εγκατάστασης απαιτεί τη λήψη του πηγαίου κώδικα από το παρόν αποθετήριο, μέχρι να ξεπεράσουμε την beta φάση και να συσκευάσουμε για τις κύριες διανομές τον κώδικα. Συγκεκριμένα:

1. Αρχικά, κλωνοποιούμε το αποθετήριο:
```bash
git clone -b master https://github.com/JohnGavr/askfetch && cd askfetch
```
2. Στη συνέχεια εκτελούμε το askfetch.sh με τις κατάλληλες παραμέτρους:
```bash
bash ./askfetch.sh
```
### Συμβατές διανομές
Το askfetch είναι συμβατό με τη παρακάτω λίστα διανομών (η λίστα αυτή ανανεώνεται συνεχώς και θα βοηθούσε πολύ αν προσθέτατε και τη δική σας διανομή):

* Systemd διανομές οι οποίες διαθέτουν το αρχέιο /etc/os-release (info για το  /etc/os-release [εδώ](http://0pointer.de/blog/projects/os-release.html))

## Χρήση
```bash
Askfetch.sh system information tool.

 Options:
  -l,	  Script locale (e.g. el,en). Default is en.
  -d, 	Distribution logo. Default is current installed distribution.
  -h, 	Display this help and exit
"
```

### Λογότυπο ορισμένης διανομής `-d <distro_id>`
Για παράδειγμα ./askfetch.sh -d ubuntu υποχρεώνει την εμφάνιση του λογοτύπου ubuntu.txt
### Γλώσσα διεπαφής `-l <κωδικός_γλώσσας>` 
Παράδειγμα:
* Ελληνικά: ./askfetch.sh -l el
* Αγγλικά: ./askfetch.sh -l en

Η default γλώσσα διεπαφής είναι η Αγγλική.

*Οδηγίες για μετάφραση του προγράμματος καθώς και για τον κώδικα bash που επιτρέπει την φόρτωση μεταφρασμένων strings [εδώ](https://www.linuxjournal.com/content/internationalizing-those-bash-scripts)*


## Logos διανομών 
Τα λογότυπα των διανομών που εμφανίζονται στο bash script αυτό τοποθετούνται στον φάκελο `./logos` και διαθέτουν συγκεκριμένη μορφή. Είναι ASCII `.txt` αρχεία όπως το ακόλουθο (για την διανομή Manjaro):

### manjaro.txt
```
label_color: \e[0m\e[1;32m
logo:
\e[0m\e[1;32m
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ██████████████████  ████████    
\e[0m\e[1;32m ████████            ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████    
\e[0m\e[1;32m ████████  ████████  ████████
```

Το πεδίο `label_color:` παίρνει τιμές 8-bit color. Για περισσότερες πληροφορίες [εδώ](https://misc.flogisoft.com/bash/tip_colors_and_formatting)

Το πεδίο `logo` αποτελεί το λογότυπο σε ascii χαρακτήρες, το οποίο περιέχει χρώματα στα σημεία που απαιτείται.

Τα αρχεία στον φάκελο `logos`  έχουν ονομασία η οποία πρέπει να είναι της μορφής [distro_id].txt. Ένας εύκολος τρόπος εύρεσης του κατάλληλου ονόματος είναι ο παρακάτω:
```bash
echo $(cat /etc/os-release | grep "ID=" | cut -d '=' -f2).txt
```

## Επόμενα βήματα
Κατευθυνθείτε στα ανοικτά [issues](https://github.com/JohnGavr/askfetch/issues) για μία λίστα απο προτεινόμενες λειτουργίες προς υλοποίηση.

## Πώς να συμβάλλετε
Συμβουλευτείτε τον [αντίστοιχο οδηγό](https://github.com/JohnGavr/askfetch/CONTRIBUTING.md) για οδηγίες σχετικά με την υποβολή κώδικα.

## Άδεια χρήσης
Η άδεια χρήσης του askfetch είναι [αδεια χρήσης εδώ]

## Επικοινωνία
Μπορείτε να επικοινωνήσετε μέσω issue απο εδώ είτε στο αντίστοιχο thread του [Linux User GR](https://linux-user.gr/t/askfetch-plhrofories-systhmatos/)

## Ευχαριστίες
* [Linux User GR](https://linux-user.gr/) για τις συμβουλές σχετικά με την υλοποίηση και τις λειτουργίες του askfetch. 
* screenfetch
* neofetch

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[commits-activity-shield]: https://img.shields.io/github/commit-activity/m/JohnGavr/askfetch.svg
[commits-activity-url]: https://github.com/JohnGavr/askfetch/graphs/commit-activity/

[contributors-shield]: https://img.shields.io/github/contributors/JohnGavr/askfetch.svg
[contributors-url]: https://github.com/JohnGavr/askfetch/graphs/contributors
[license-shield]: https://img.shields.io/github/license/JohnGavr/askfetch.svg
[license-url]: https://choosealicense.com/licenses/gpl-3.0/
[repo-size-shield]: https://img.shields.io/github/repo-size/JohnGavr/askfetch.svg
[repo-size-url]: https://github.com/JohnGavr/askfetch/
