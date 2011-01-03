
// gcc -O3 -funroll-loops -Wall scan_dns.c -o scan_dns

#include <stdio.h>
#include <stdint.h>
#include <sys/socket.h>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <syslog.h>
#include <errno.h>
#include <stdlib.h>

const char* dns_payload = "\x0a\x25\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00\x03"
    "\x77\x77\x77\x05\x63\x69\x73\x63\x6f\x03\x63\x6f\x6d\x00\x00\x01\x00\x01\x00";
    
const unsigned dns_payload_size = 31;

int main(int argc, char* argv[])
{
    uint32_t ip_from;
    uint32_t ip_to;
    int sockfd;
    struct sockaddr_in servaddr;
    uint32_t i;
    unsigned delay = 0;
    
    if (argc < 3) {
        printf("Usage: %s <ip from> <ip to> [delay]\n", argv[0]);
        return 1;
    }
    
    if (argc == 4)
        delay = atoi(argv[3]);

    ip_from = ntohl(inet_addr(argv[1]));
    ip_to = ntohl(inet_addr(argv[2]));

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd == -1) {
        printf("Error creating socket\n");
        return 2;
    }

    memset(&servaddr, 0x0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = ntohs(53);

    for (i = ip_from; i < ip_to; i++) {
        servaddr.sin_addr.s_addr = htonl(i);
        if (sendto(sockfd, dns_payload, dns_payload_size, 0, (struct sockaddr*)&servaddr, 
                sizeof(servaddr)) == -1) {
            switch(errno) {
                case 13:
                    break;
                default:
                    printf("Error send datagram to %u: %s\n", i, strerror(errno));
                    return 3;
            }
        }
        
        usleep(delay);
    }
    
    //syslog(LOG_INFO, "Ending scan %s -> %s", argv[1], argv[2]);
    
    return 0;
}
