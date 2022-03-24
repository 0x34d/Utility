#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <netinet/tcp.h>

#define PORT 8080

int read_write(int sockfd,char *Input_file){
    FILE *infile;
    long numbytes;
    char *buffer;
    char data[2048];

    //Open the file
    infile = fopen(Input_file,"rb");
    if (infile == NULL){
        printf("Cannot open file \n");
        return 0;
    }

    fseek(infile, 0L, SEEK_END);    // Get the number of bytes
    numbytes = ftell(infile);
    fseek(infile, 0L, SEEK_SET);    //reset the file position indicator to the beginning of the file

    //Allocate the Buffer of user input 
    buffer = (char*)calloc(numbytes, sizeof(char));
    if(buffer == NULL){
        return 0;
    }

    // Get input from the user:
    fread(buffer, sizeof(char), numbytes, infile);

    // Send the message to server:
    write(sockfd, buffer, numbytes);

    // Receive the server's response:
    read(sockfd,data,2048);

    printf("Server's response: %s\n",data);

    fclose(infile);
    free(buffer);
    return true;
}


int main(int argc, char *argv[]){

    int sockfd; 
    struct sockaddr_in serv_addr;

    // Create socket:
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        printf("\n Socket creation error \n");
        return -1;
    }else
        printf("Socket created successfully\n");

    // Set port and IP the same as server-side:

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    // Send connection request to server:
    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) != 0) {
        printf("connection with the server failed...\n");
        exit(0);
    }
    else
        printf("connected to the server..\n");

    read_write(sockfd,argv[1]);

    close(sockfd);
}
