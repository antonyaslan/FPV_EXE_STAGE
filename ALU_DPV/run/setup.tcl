setenv VC_STATIC_HOME  "/usr/local-eit/cad2/synopsys/vcf24/vc_static/V-2023.12"

setenv PATH "$VC_STATIC_HOME/bin:${PATH}"

setenv SNPSLMD_LICENSE_FILE `/bin/cat $VC_STATIC_HOME/../../../current_license`
