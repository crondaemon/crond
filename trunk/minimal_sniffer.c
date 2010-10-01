#include <pcap.h>
#include <stdio.h>

void packet_process(u_char *args, const struct pcap_pkthdr *header,
	    const u_char *packet)
{
    // Print the IP header
    unsigned i;
    printf("Packet of size %4u -> ", header->len);
    for (i = 0; i < 20; i++)
        printf("%.2X:", packet[i + 14]);
    printf("\n");
}


int main(int argc, char *argv[])
{
    pcap_t *handle;			        // Session handle
    char *dev;			            // The device to sniff on
    char errbuf[PCAP_ERRBUF_SIZE];	// Error string 
    struct bpf_program fp;		    // The compiled filter 
    char filter_exp[] = "ip";       // The filter expression 
    bpf_u_int32 mask;		        // Our netmask 
    bpf_u_int32 net;		        // Our IP 

    // Define the device 
    dev = pcap_lookupdev(errbuf);
    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        return(2);
    } else {
        printf("Minimal sniffer running on device %s\n", dev);
    }
    
    // Find the properties for the device 
    if (pcap_lookupnet(dev, &net, &mask, errbuf) == -1) {
	    fprintf(stderr, "Couldn't get netmask for device %s: %s\n", dev, errbuf);
	    net = 0;
	    mask = 0;
    }
    
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

