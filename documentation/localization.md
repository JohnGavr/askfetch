# Localization guide
This is a step by step guide to translate `askfetch.sh` using gettext.

1. Update the `askfetch.pot` file from the latest source code:

 ```bash
 cd [location of askfetch.sh]
 xgettext -L Shell -o askfetch.pot askfetch.sh
 ``` 
2. Create a new directory for the desired locale 

 ```bash
 mkdir -p askfetch/locale/locale_id/LC_MESSAGES/
 ```

Where locale_id follows restrictions stated [here](https://www.gnu.org/software/gettext/manual/gettext.html#Locale-Names).

3. Copy updated askfetch.pot in `askfetch/locale/locale_id/`

 Copy `askfetch.pot` file and rename it to `locale_id.po`

 ```bash
 cp askfetch/askfetch.pot askfetch/locale/locale_id/locale_id.po
 ```    

4. Fill the `.po` file using either a relevant editor (e.g. PoEdit) or manually, preserving all `$var_name` variables

5. Create machine object file from `.po` 

 ```bash
 msgfmt -o LC_MESSAGES/askfetch.mo locale_id.po
 ```

After machine object file creation, localization of `askfetch.sh` is finished.