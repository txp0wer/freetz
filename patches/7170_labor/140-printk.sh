[ "$DS_VERBOSITY_LEVEL" -ge 1 ] && echo "${L1}applying printk.patch"

if [ "$DS_TYPE_LABOR_PHONE" == "y" ]
then
    modpatch "$FILESYSTEM_MOD_DIR" "$PATCHES_DIR"/cond/printk_7170_labor_phone.patch
else
    modpatch "$FILESYSTEM_MOD_DIR" "$PATCHES_DIR"/cond/printk_7170_labor.patch
fi