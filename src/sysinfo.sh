#
#  Function to display system information including uptime, kernel version, OS, and version.
#
function sysInfo() {
   echo -e -n "$Dim[Sys-Info]"
   echo -e -n "$ColorReset""➜ [$Dim Uptime$Blue$UPTIME$ColorReset$Dim ★ Kernel$Blue $KERNEL$ColorReset$Dim ★ $OS $Blue$OS_RELEASE-$OS_VERSION $ColorReset] "
}