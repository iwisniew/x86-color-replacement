#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int sepia(void* img,int dist, int Rsel, int Gsel, int Bsel);

int main() {
    char* buff;
    FILE *input,*output;
    unsigned int len;

    input = fopen("tiger.bmp","rb");
    if (input==NULL){
        printf("Error opening the file\n");
        return 1;
    } else printf("File opened successfully\n");

    fseek(input, 0, SEEK_END);
    len = ftell(input);
    fseek(input, 0, SEEK_SET);

    buff = (char *)malloc(sizeof(unsigned char) * len);
    if (buff == NULL) {
        printf("Memory error\n");
        fclose(input);
        return 1;
    } else printf("Memory allocated successfully\n");

    fread(buff,len, 1, input);
    fclose(input);

    int dist = 442;     // dist should be in range (0-442) 442 for the whole image
    dist=dist*dist;
    int Rsel = 23;
    int Gsel = 50;
    int Bsel = 30;

    int result;
    result = sepia(buff+54,dist, Rsel, Gsel,Bsel);

    output = fopen("tiger_sepia.bmp","wb");
    fwrite(buff,len,1,output);
    fclose(output);
    printf("File saved\n");
    //printf("%i\n",result);
    free(buff);
    return 0;
}
