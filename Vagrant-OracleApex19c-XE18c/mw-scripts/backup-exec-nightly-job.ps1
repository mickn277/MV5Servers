# Requirements:
# Must start in vagrant root directory.
# .\mw-scripts\backup-exec-nightly-job.ps1

# BUG: This fails with password prompt
vagrant ssh -c "sudo su - oracle '/vagrant/mw-scripts/backup-OraXE18c-full-offline.sh'"
