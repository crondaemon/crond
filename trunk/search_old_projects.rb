
projects_root = [
    "casirasco",
    "common",
    "DataGen",
    "ddt",
    "Depot",
    "gpon",
    "HLM",
    "jedi",
    "ludmilla",
    "mati",
    "medusa",
    "microsd",
    "moses",
    "NacProfiler",
    "NGN2",
    "pinga",
    "prometeo",
    "rblmon",
    "rds",
    "sad",
    "SCACCO",
    "scarlet",
    "test",
    "VirtualToken",
    "virtus",
    "web",
    "webtest",
    "zeus"
]

projects = [
    "FeaturesDetection",
    "FeaturesDetectionMada",
    "SPID-paper",
    "be-secure-release",
    "c++utils",
    "crypto-face",
    "dns_bot_digger",
    "eagle_event_manager",
    "eagle_manager",
    "eagle_php",
    "eagle_protocol",
    "face-recog",
    "face-recog-2SVM",
    "face-recog-lbp",
    "findneagle",
    "fourier-lucia-2",
    "historic",
    "jack",
    "libPHP",
    "libeagle-ng",
    "linux-alarm",
    "local_packages",
    "logarchiver",
    "neagle",
    "pam_radius",
    "panbackup",
    "projects-config",
    "projects-mirror",
    "rex",
    "rtc",
    "s2f",
    "signtunnel",
    "simdesktop",
    "simlogon",
    "simmail",
    "simvpn",
    "sip-stress",
    "skifmwk2",
    "skiinstall",
    "snort",
    "spids-g",
    "tcpreplay_fast",
    "tesiriccardov",
    "turbo_call_dll",
    "ulinux"
]

SVN_BASE="https://svn.be-secure.it/svn/common"

outfile = File.new("output_search.txt", "w")

projects.each do |project|
    puts "Searching project #{project}"
    h = Hash.new

    output = `svn info #{SVN_BASE}/#{project}`
    output.each do |o|
        t = o.split(':')
        h[t[0]] = t[1]
    end
    
    date = h['Last Changed Date'].chomp
    author = h['Last Changed Author'] ? h['Last Changed Author'].chomp : "unknown" 

    result = "#{project}\t#{date}\t(by #{author})"
    puts result
    outfile.write("#{result}\n")
end

outfile.close
