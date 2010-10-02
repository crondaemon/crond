/*

    Minimal sniffer written by Dario Lombardo
    
    This an educational purpose sniffer written for the Linux Day Torino 2010
    that demonstrates how the skeleton of a pcap-based sniffer is.

    Compile with
    gcc minimal_sniffer.c -o minimal_sniffer -lpcap
    
    Requires root privileges to run.

    It sniffs from the first available device and applies the "ip" pcap filter.
        
*/

#include <stdio.h>
#include <pcap.h>
#include <arpa/inet.h>
#include <netinet/ip.h>

void packet_process(u_char *args, const struct pcap_pkthdr *header,
	    const u_char *packet)
{
    unsigned i;
    struct iphdr* iph;
    char ip_from[20];
    char ip_to[20];

    // skip 14 bytes (ethernet)
    iph = (struct iphdr*)(packet + 14);
    
    printf("Size %4u: %s -> %s", header->len, 
        inet_ntop(AF_INET, &iph->saddr, ip_from, 20),
        inet_ntop(AF_INET, &iph->daddr, ip_to, 20));
    
    #ifdef DUMP_PACKET
    printf(" [");
    for (i = 0; i < 20; i++)
        printf("%.2X:", packet[i + 14]);
    printf("]");
    #endif
    
    printf("\n");
}


int main(int argc, char *argv[])
{
    pcap_t *handle;                // Session handle
    char *dev;                     // The device to sniff on
    char errbuf[PCAP_ERRBUF_SIZE]; // Error string 
    struct bpf_program fp;         // The compiled filter 
    char filter_exp[] = "ip";      // The filter expression 
    bpf_u_int32 mask;              // Our netmask 
    bpf_u_int32 net;               // Our IP
    char bufnet[20];               // Print buffer
    char bufmask[20];              // Print buffer

    // Get the first available device 
    dev = pcap_lookupdev(errbuf);
    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        return(2);
    } else {
        printf("\nMinimal sniffer running on device %s\n\n", dev);
    }
    
    // Find the properties for the device 
    if (pcap_lookupnet(dev, &net, &mask, errbuf) == -1) {
	    fprintf(stderr, "Couldn't get netmask for device %s: %s\n", dev, errbuf);
	    net = 0;
	    mask = 0;
    } else {
        printf("Device ip: %s/%s\n\n", inet_ntop(AF_INET, &net, bufnet, 20),
            inet_ntop(AF_INET, &mask, bufmask, 20));
    }
    
    printf("Press ENTER to start sniffing.");
    getchar();
    
    // Open the session in promiscuous mode 
    handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
    if (handle == NULL) {
	    fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
	    return(2);
    }
    
    // Compile and apply the filter 
    if (pcap_compile(handle, &fp, filter_exp, 0, net) == -1) {
	    fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
	    return(2);
    }
    
    if (pcap_setfilter(handle, &fp) == -1) {
	    fprintf(stderr, "Couldn't install filter %s: %s\n", filter_exp, pcap_geterr(handle));
	    return(2);
    }

    // Run the loop
    pcap_loop(handle, -1, packet_process, NULL);

    // And close the session 
    pcap_close(handle);
    return(0);
}

