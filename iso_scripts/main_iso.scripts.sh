echo "=============== [main_iso_scripts] ==============="
# =============== [Settings - DNS && Mount proc ,sys ,dev/pts] ===============
bash chroot_start.sh

# =============== [Install Packages] ===============
bash chroot_install.sh

# # =============== [Deploy Features] ===============
# bash chroot_feature_new.sh

# =============== [Build Projects] ===============
bash chroot_build_new.sh

# # =============== [Change Other Settings] ===============
# bash chroot_other_settings.sh

# # =============== [Deploying HTTPS Environment] ===============
# if [ "$IS_HTTPS" == "1" ]; then
#     bash chroot_deploy_https.sh
# fi

# =============== [Close All service] ===============
bash inactive_service.sh

# =============== [Clean All && Umount All] ===============
bash chroot_end.sh