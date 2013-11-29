[ "$FREETZ_REMOVE_WEBDAV" == "y" ] || return 0

echo1 "removing AVM webdav files"
for files in \
  lib/libexpat.so* \
  lib/libneon.so* \
  sbin/*mount.davfs \
  etc/onlinechanged/webdav_net \
  etc/webdav_control \
  usr/www/all/html/de/home/home_webdav.txt \
  bin/webdavcfginfo \
  ; do
	rm_files "${FILESYSTEM_MOD_DIR}/$files"
done

if [ ! "$FREETZ_PACKAGE_DAVFS2" == "y" ]; then
	rm_files "${FILESYSTEM_MOD_DIR}/usr/share/ctlmgr/libctlwebdav.so"

	# patcht Heimnetz > Speicher (NAS) > Speicher an der FRITZ!Box
	sedfile="${HTML_LANG_MOD_DIR}/storage/settings.lua"
	if [ -e "$sedfile" ]; then
		echo1 "patching ${sedfile##*/}"
		sedrows=$(cat $sedfile |nl| sed -n 's/^ *\([0-9]*\).*id="devices_table_online".*$/\1/p')
		sedrowe=$(cat $sedfile |nl| sed -n 's/^ *\([0-9]*\).*id="webdavIndexState".*$/\1/p')
		modsed "$((sedrows)),$((sedrowe+2))d" $sedfile
		modsed 's/if not(g_webdav_enabled)/& or true/' $sedfile
	fi
		
	echo1 "patching rc.conf"
	modsed "s/CONFIG_WEBDAV=.*$/CONFIG_WEBDAV=\"n\"/g" "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"
fi
